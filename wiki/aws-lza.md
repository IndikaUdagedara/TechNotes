---
concept: aws-lza
summary: Landing Zone Accelerator on AWS (LZA): deploying to a new account with Universal Configuration, Entra ID SSO, managed AD, and the AWS networking concepts (TGW, Direct Connect, VPN, Azure connectivity) behind LZA network design
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
- UC's `iam-config.yaml` lives at `modules/base/default/iam-config.yaml` in the repo (the earlier `.../config/` path 404s). It sets `identityCenter` with `delegatedAdminAccount: SharedServices` and `providers: []`. I haven't read its permission sets in full.
- The Entra setup is manual in the console. Nothing in the sources shows LZA automating the Entra side.
- UC does not configure Macie alerting automatically.
- UC SCPs: AWS Organizations allows 5 SCPs per account or OU. UC attaches some at account level to reserve quota for Control Tower Region deny.
- UC Getting Started and Security docs also exist as `docs/02-Getting-Started` and `docs/04-Security-Identity-Compliance` in the repo.

## What the Universal Configuration is
Source: README of aws/lza-universal-configuration.
- Ready-made LZA config files plus docs, used as a baseline instead of writing config from scratch.
- `modules/base/default` is the base (security, governance, organization). `modules/network` holds the hub-and-spoke and Shared VPC patterns. Also `docs/` (numbered guides 01-08), `replacements/`, `scripts/`, and an example `.gitlab-ci.yml`.
- Options: base only, base + hub-and-spoke, or base + Shared VPC. Shared VPC costs slightly less than hub-and-spoke.
- LZA also supports container-based deployment (for Regions without CodeBuild/CodePipeline), and the optional `lza-mcp-server` can guide a UC merge.
- It does not make you compliant by itself. It is an opinionated baseline you must review.

## Directory services in LZA (Managed AD)
- LZA has no setting called "enterprise directory". The closest is `managedActiveDirectories` in `iam-config.yaml` (AWS Managed Microsoft AD, `edition: Enterprise`). Source: IamConfig typedoc (v1.9.2).
- Key properties: `account`, `region`, `dnsName`, `netBiosDomainName`, `vpcSettings` (VPC and subnets from network-config), `resolverRuleName`, `secretConfig` (where the admin secret is stored), `sharedOrganizationalUnits`, `logs`, and `activeDirectoryConfigurationInstance`.
- `activeDirectoryConfigurationInstance` is an LZA-provisioned Windows EC2 instance that joins the domain and runs your PowerShell scripts (`ad-config-scripts/`) to create AD groups, users, memberships, permissions and the password policy.
- UC does NOT deploy a directory by default. Its Management & Governance doc says SharedServices "can be further configured to support" directory services.
- Identity Center with an AD source needs the directory in the delegated admin account (SharedServices in UC), in the same Region as Identity Center. Only one directory can be connected. This conflicts with the typedoc example, which puts the directory in `Network`.
- For Entra ID, use SAML + SCIM with Identity Center (see above), not Managed AD.

## Entra ID: recommended method
- AWS and Microsoft both document IAM Identity Center with Entra ID as an external IdP: SAML 2.0 for sign-in, SCIM 2.0 for provisioning users and groups.
- SAML cannot query the IdP for users and groups, so they must be provisioned (SCIM or manual) before assignments.
- Microsoft's note: with AWS Organizations, delegate another account as the Identity Center admin account and set up Entra SSO there, not in the management account. UC already delegates to SharedServices.
- Entra quirks: nested groups don't sync, removed attributes aren't removed in Identity Center, guest accounts need a Name ID claim change, duplicate multi-values (e.g. phoneNumbers) cause SCIM 400 errors.
- LZA's `identityCenter` config only manages permission sets and assignments. I found nothing showing LZA configures the identity source. Assignments reference principals by name, so synced groups probably must exist before the pipeline runs (inference).
- `providers` in `iam-config.yaml` creates IAM SAML providers (IAM role federation), a different mechanism from Identity Center.

## AWS networking concepts behind LZA network design
Sources: VPC User Guide, Transit Gateway guide, Site-to-Site VPN guide, Direct Connect guide.

### VPC route propagation
- Propagation lets a virtual private gateway (VGW) add VPN/Direct Connect routes to a VPC route table automatically (enabled per route table).
- Priority: longest prefix first. For the same destination: static routes (IGW, NAT, peering, TGW, gateway endpoint) beat prefix list routes, which beat propagated routes. Among propagated: Direct Connect BGP, then VPN static, then VPN BGP.
- You can only edit routes you added yourself.

### VGW and customer gateway
- VGW: the AWS-side VPN concentrator, attached to one VPC. Default ASN 64512 (can't change after creation). No IPv6 for Site-to-Site VPN (use TGW or Cloud WAN).
- Customer gateway device: the physical or software device on your side. Customer gateway: the AWS resource describing it (public IP and BGP ASN).
- A VPN connection always has 2 tunnels. It can terminate on a VGW or a Transit Gateway.

### Transit Gateway (TGW) route tables
- Attachment: VPC, VPN, Direct Connect gateway, Connect, peering, and so on.
- Association: which TGW route table an attachment looks routes up in. One table per attachment, but a table can have many attachments.
- Propagation: which TGW route tables an attachment advertises its routes into. One or more tables.
- Association chooses what an attachment can reach. Propagation chooses who can reach it. Together they implement segmentation (prod/dev isolation, shared services).
- A new TGW has a default table that is both the default association and propagation table (centralized router pattern).
- A VPC attachment propagates its CIDRs. VPN/DX attachments propagate BGP-learned routes. Peering attachments are static only. You can't filter advertised routes.
- VPC subnet route tables still need a static route to the TGW (e.g. `0.0.0.0/0 -> tgw-id`).
- TGW priority: most specific prefix, then static, prefix list, VPC-propagated, DX gateway, Connect, VPN over DX, VPN, and so on. Ties between the same attachment type are broken by BGP (shorter AS path, lower MED, eBGP over iBGP). Only the preferred route is shown.
- Blackhole routes are supported.

### Direct Connect (DX)
- Dedicated private fiber link to a DX location. A connection is dedicated (from AWS) or hosted (from a partner). It is not encrypted by default.
- VIF types: private (one VPC via a VGW, or many via a DX gateway), public (public AWS services), transit (to TGWs via a DX gateway).
- Your router needs BGP with MD5, 802.1Q VLANs and single-mode fiber. BFD is optional.
- Setup: request the connection (up to 72 business hours), download the LOA-CFA for the cross-connect, create the VIF (VLAN, BGP ASN, peer IPs, MD5 key, target, MTU), download the router config and apply it, then verify and add redundancy.
- VIF settings go in the Direct Connect console (AWS side) plus the router config (your side). The VLAN can't be changed after creation.
- Resiliency Toolkit models: Maximum (99.99%, separate devices in 2+ locations), High (99.9%, 2 locations), Dev/Test (one location). A multi-site campus counts as one location. Active/active is recommended.
- Pricing: port hours plus outbound data transfer.

### VPN over Direct Connect
- Public IP VPN: use a public VIF to reach the VPN endpoints, then create a normal Site-to-Site VPN to the TGW.
- Private IP VPN (recommended): runs over a transit VIF through a DX gateway to a TGW, with private IPs on both tunnel ends. No public IPs, no extra VPN gear, higher route limits (5000 out / 1000 in versus DX alone 200 / 100).
- Steps: give the TGW a private CIDR (no overlap), create the DX gateway, associate the DX gateway with the TGW (put the CIDR in allowed prefixes), create a customer gateway with a private RFC 1918 IP (a loopback or LAN address, not the BGP point-to-point IPs), create the VPN connection to the TGW with Outside IP type `PrivateIpv4` and the DX gateway's TGW attachment as the transport attachment.

### Connecting AWS to Azure
Sources: AWS Networking blog (Aug 2026), Microsoft Learn (Azure Multicloud Interconnect, AWS BGP VPN tutorial).
- Site-to-Site VPN over the internet: AWS VPN to a TGW or VGW, Azure VPN gateway (active-active, BGP). Microsoft's tutorial uses 4 tunnels, `/30` inside CIDRs from the APIPA range 169.254.21.0 to 169.254.22.255, and different ASNs on each side. About 1.25 Gbps per tunnel.
- AWS Interconnect - multicloud: managed private link with MACsec and 4-way redundancy. GA for Google Cloud and OCI. Azure is in PREVIEW (announced Aug 31 2026): 1 Gbps, one gateway connection per interconnect, no SLA, limited Regions, needs an Azure ExpressRoute virtual network gateway. Azure reserves ASNs 65515-65520 and 169.254.255.0/24. Don't use for production yet.
- Direct Connect + ExpressRoute through a provider: the traditional private route. I haven't verified the details.
- Many VPCs: terminate on a TGW, which fits an LZA hub-and-spoke design.
