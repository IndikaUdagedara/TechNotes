---
concept: aws-lza
summary: Landing Zone Accelerator on AWS (LZA): deploying to a new account with Universal Configuration and Entra ID SSO
aliases:
  - lza
  - landing zone accelerator
  - lza universal configuration
---

# aws-lza

# AWS Landing Zone Accelerator (LZA)

Sources: LZA implementation guide (docs.aws.amazon.com/solutions/latest/landing-zone-accelerator-on-aws), the aws/lza-universal-configuration repo (UC), and the IAM Identity Center user guide (Entra ID tutorial).

## Deployment flow for a brand-new account

### Decisions up front
- Use a new AWS Organization with no Control Tower. UC defaults to Control Tower and works best on a clean org.
- Pick a home Region where Control Tower is available.
- Plan 6 unique emails: Management, LogArchive, Audit, SharedServices, Network, Perimeter.
- Choose the config repo location (CodeCommit, S3 or CodeConnections). Changing `Configuration Repository Location` after install causes stack failures.

### Prerequisites (management account)
- Create the Organization with all features enabled (LZA enables them if missing).
- For the auto-deploy Control Tower path:
  - No IAM Identity Center configured in the management account.
  - No services enabled for Organizations, no OUs, management account is the only account.
  - No Control Tower service roles present.
- Raise the CodeBuild quota "Concurrently running builds for Linux/Large environment" to at least 3 and wait for approval.
- Keep `us-east-1` (global Region) reachable. Don't block it with SCPs or Control Tower Region deny.
- Create a GitHub PAT with `public_repo`. Store it in Secrets Manager in the home Region as plaintext `accelerator/github-token`, rotation disabled.

### Deploy
1. Launch `AWSAccelerator-InstallerStack` (CloudFormation, home Region, about 8 min). Key parameters: Branch Name (latest release), the 3 core emails, `Control Tower Environment`=Yes, `Enable Approval Stage`=Yes, Configuration Repository Location. Acknowledge IAM resource creation.
2. Wait for `AWSAccelerator-Installer` and then `AWSAccelerator-Pipeline` (first run about 45 min). LZA creates Control Tower, LogArchive and Audit.

### Apply Universal Configuration (UC)
1. Download the zip from the UC releases page (base config plus a network model: hub-and-spoke or shared VPC).
2. Copy the UC `config/` over the config pulled from your repo location, overwriting duplicates.
3. Edit `accounts-config.yaml`: real emails for all 6 accounts.
4. Edit `replacements-config.yaml`: `HomeRegion`, `EnabledRegions`, `BudgetsEmail`, `SecurityHigh`, `SecurityMedium`, `SecurityLow`.
5. Push, release a change on `AWSAccelerator-Pipeline`, approve at the manual stage.
- Cost note from UC: about $1,372/month for hub-and-spoke with no workloads, mostly Network Firewall and VPC.

## Root user vs IAM user for bootstrap
This is general AWS guidance, not from the LZA or UC docs.
- Use root once: strong password, MFA (ideally two devices), check contacts.
- Create a temporary named IAM admin user with MFA and do the deploy as that user. IAM Identity Center can't be used yet because LZA requires none in the management account at deploy time.
- Don't create root access keys. Vault the credentials and alert on root sign-in.
- After Entra SSO works, delete the IAM user (or keep it as MFA-protected, alerted break-glass).
- SCPs from UC deny root in member accounts but never restrict the management account.
- The `AdministratorAccess` recommendation is my inference. The docs specify no minimum policy for the installer launcher.

## Entra ID SSO with IAM Identity Center
UC only states that Identity Center is the human-access foundation (SAML 2.0/SCIM from the corporate IdP, SharedServices as delegated administrator). It has no Entra-specific steps. The steps below come from the IAM Identity Center Entra tutorial.

1. Enable Identity Center (or confirm Control Tower did). Requires an Organization instance.
2. In Entra, add the "AWS IAM Identity Center" gallery enterprise app (needs at least Cloud Application Administrator).
3. In Identity Center: Settings, Identity source, Change identity source, External identity provider. Copy the AWS access portal sign-in URL and download the SP metadata.
4. In Entra, set up SAML SSO: upload the SP metadata, paste the sign-in URL, download the Federation Metadata XML.
5. Upload that XML in Identity Center and type `ACCEPT`. Warning: changing the identity source can remove existing user and group assignments, so do it early.
6. Enable automatic provisioning (SCIM) in Identity Center. The endpoint and token are shown once. In Entra, go to Provisioning, Automatic, enter the tenant URL and token, test the connection, start provisioning.
7. Assign Entra groups to the Entra app.
   - Entra can't provision nested groups. Only direct members sync.
   - Dynamic groups sync but aren't flattened across nesting.
   - Guest users need a Name ID claim fix (`user.mail` for external guests).
8. Create permission sets, assign groups to accounts, and test sign-in from My Apps.
9. Optional ABAC: add `AccessControl:<Attribute>` claims.

## Gotchas and open items
- Timing conflict: LZA needs no Identity Center in the management account at deploy time, but the Entra tutorial assumes it is enabled. Do SSO after the first pipeline run succeeds.
- Not verified: how UC's `iam-config` wires Identity Center delegated admin and permission sets (fetching it at `modules/base/default/config/iam-config.yaml` returned 404). Check the release zip.
- The Entra setup is manual in the console. Nothing in the sources shows LZA automating the Entra side.
- UC does not configure Macie alerting automatically.
- UC SCPs: AWS Organizations allows 5 SCPs per account or OU. UC attaches some at account level to reserve quota for Control Tower Region deny.
- UC Getting Started and Security docs also exist as `docs/02-Getting-Started` and `docs/04-Security-Identity-Compliance` in the repo.
