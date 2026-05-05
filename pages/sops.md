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