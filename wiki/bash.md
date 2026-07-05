# Bash

## General Commands

- Clean shell cache: `hash -r`
- Find where command is in path: `type -a vim`

## Mediaserver

```bash
arp -na | grep a8:42:a1:1d:45:cb | awk -F ' ' '{print $2}' | sed -e 's/(//' | sed -e 's/)//'
```

## Docker

### Colima

**Start colima on Mac**

Intel:
```bash
colima start --vm-type=vz
```

M1/M3:
```bash
colima start --arch aarch64 --vm-type=vz --vz-rosetta
```

**Adjust CPU/Memory**

```bash
colima stop
colima start --cpu 4 --memory 8
```

**Set Docker Socket**

```bash
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
```

## tmux

- Save sessions: `<prefix>+s`
- Restore sessions: `<prefix>+r`
- Rename session: `<prefix>+$`
- Kill server: `tmux kill-server`

## age & sops

### Use SSH Keys

**Encrypt using public key**

```bash
age --encrypt -R ~/.ssh/id_rsa.pub x > y
```

**Decrypt using private key**

```bash
age --decrypt -i ~/.ssh/id_rsa y
```
