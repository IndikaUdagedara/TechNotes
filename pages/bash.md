- Clean shell cache `hash -r`
- Find where command is in path `type -a vim`
- mediaserver
  - `arp -na | grep a8:42:a1:1d:45:cb | awk -F ' ' '{print $2}' | sed -e 's/(//' | sed -e 's/)//'`

    ***
- [[Docker]]
  - Colima
    - Start colima on mac
      - Intel `colima start --vm-type=vz`
      - M1/3 colima on mac
        `colima start --arch aarch64 --vm-type=vz --vz-rosetta`
    - Adjust cpu/mem
      ```
      colima stop
      colima start --cpu 4 --memory 8
      ```
  - Set docker socket
    `export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"`
- ## tmux
- Save sessions: `<prefix>+s`
- Restore sessions: `<prefix>+r`
- Rename session: `<prefix>+$`
- Kill server `tmux kill-server`

  ***

- ## age & sops
- Use SSH keys
  - encrypt using public key `age --encrypt -R ~/.ssh/id_rsa.pub x > y`
  - decrypt using private key ` age --decrypt -i ~/.ssh/id_rsa y`
