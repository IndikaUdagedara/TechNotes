# sops

## Concepts
SOPS works with 
- a sops configuration file (`.sops.yaml`) and
- an encrypted secret file  (_sops file_ e.g., `secrets/example.yaml`)

`.sops.yaml` contains instructions to sops on who should be able to decrypt the secrets and which secret file names are to be considered.

E.g., 
```yaml
keys:
  - &indika_mediaserver age...k1
  - &indika_thinkpad age...k2

creation_rules:
  - path_regex: secrets/.*\.yml$
    key_groups:
      - age:
          - *indika_mediaserver
          - *indika_thinkpad
```

sops will use it to encrypt/decrypt files matching the patterns under `creation_rules`. According to the example, it will look at `secrets/*.yml` and allow secrets to be encrypted for 2 keys.


## Usage with sops-nix

  1. Generate age keypair (on each host)
```
   sudo mkdir -p /var/lib/sops-nix
   sudo age-keygen -o /var/lib/sops-nix/key.txt
   sudo chmod 600 /var/lib/sops-nix/key.txt
   # Note the public key printed: age1xxxxxxxxx...
```

  2. NixOS config (thinkpad & mediaserver)
```
   imports = [ inputs.sops-nix.nixosModules.sops ];
   
   sops.age.keyFile = "/var/lib/sops-nix/key.txt";

   # use default sops file or sops file per secret
   # sops.defaultSopsFile = secrets/example.yaml;

   # declare secret
   sops.secrets."my-secrets" = {
      format = "yaml"
      sopsFile = "secrets/example.yaml;
   }
   
   # this is the unencrypted secret file added to /run/secrets/my-secrets
   # config.sops.secrets."my-secrets".path;

   # Use in a service:
   services.myapp.environmentFile = config.sops.secrets."my-secrets".path;
   
```
  3. .sops.yaml in repo root
```
   keys:
     - &thinkpad    age1abc...
     - &mediaserver age1def...
     - &admin       age1xyz...   # recovery key — always include this
   
   creation_rules:
     - path_regex: secrets/*\.yaml$
       key_groups:
         - age: [*admin, *thinkpad, *mediaserver]
```

  4. Create/edit secrets

```
   sops secrets/my-secret.yaml       # opens editor, saves encrypted
   sops -d secrets/my-secret.yaml    # decrypt to stdout
```

  5. Recovery after VM rebuild
```
   # Restore admin key from Bitwarden
   sudo chmod 600 /var/lib/sops-nix/key.txt
   
   nixos-rebuild switch --flake .#hostname
```

  *Golden rule*: The admin key (Bitwarden) must always be a recipient in every secret — it's the only recovery path if a host key is lost.
