# sops

## Encrypting secrets with sops + age (SSH RSA key)

### Prerequisites
- `sops` and `age` in packages (nixpkgs)
- Existing `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

### Setup

**1. Add sops-nix to flake inputs**
```nix
sops-nix = {
  url = "github:Mic92/sops-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

**2. Create `.sops.yaml` in repo root**
```yaml
keys:
  - &my_key ssh-rsa AAAA...user@host

creation_rules:
  - path_regex: secrets/.*\.yml$
    key_groups:
      - age:
          - *my_key
```
- age accepts `ssh-rsa` public keys directly as recipients (no conversion needed)
- RSA keys are supported; ed25519 is also supported

**3. Create and encrypt a secrets file**
```bash
# Delete any empty placeholder file first — sops errors on empty files with no metadata
rm secrets/llm.yml
sops secrets/llm.yml  # opens editor; save to encrypt
```

**4. Decrypt / verify**
```bash
sops -d secrets/llm.yml
```
sops auto-discovers `~/.ssh/id_rsa` as the identity for decryption.

### Gotchas
- If the file exists but is empty, sops gives "sops metadata not found" — delete and recreate
- `ssh-to-age` does NOT support RSA keys (ed25519 only) — but that tool is not needed when using SSH keys directly with age/sops
- The `keys:` block in `.sops.yaml` is optional metadata; the required part is `creation_rules`

## Decrypting on multiple hosts

Add each host's SSH public key as a recipient in `.sops.yaml`, then re-encrypt.

```yaml
keys:
  - &indika_thinkpad ssh-rsa AAAA...indika@thinkpad
  - &indika_otherhost ssh-ed25519 AAAA...indika@otherhost

creation_rules:
  - path_regex: secrets/.*\.yml$
    key_groups:
      - age:
          - *indika_thinkpad
          - *indika_otherhost
```

Re-wrap existing secrets to include the new recipient (no need to re-enter values):
```bash
sops updatekeys secrets/llm.yml
```

Any one of the listed recipients can decrypt. Both `ssh-rsa` and `ssh-ed25519` keys are supported.

## Important: Secret recovery risk

Since decryption depends entirely on your SSH private keys, **if you lose access to all private keys across all machines, the secrets are permanently unrecoverable.**

Only store secrets in sops that you can regenerate or rotate (e.g., API keys you can revoke and reissue). Do not store one-time codes, recovery keys, or anything irreplaceable.