# Sops

## Using SSH RSA keys via ssh-to-pgp

sops-nix supports age and GPG for decryption. To use an existing SSH RSA host key as a GPG key, use the [ssh-to-pgp](https://github.com/Mic92/ssh-to-pgp) tool.

### Export the public key

```bash
nix run github:Mic92/ssh-to-pgp -- -pubkey -i /etc/ssh/ssh_host_rsa_key | gpg --import
```

This prints the GPG fingerprint — record it for the .sops.yaml creation rules.

### Configure .sops.yaml

```yaml
creation_rules:
  - path_regex: secrets/.*\.yml$
    pgp: '<FINGERPRINT>'
```

### Configure sops-nix

```nix
sops.gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_rsa_key" ];
```

sops-nix will use ssh-to-pgp internally to derive the GPG key from the SSH host key at activation time.

> Note: Ed25519 SSH keys are not supported by ssh-to-pgp — use the age/ssh approach instead (sops.age.sshKeyPaths).