<div align=center>

# nixos.config

Personal NixOS + Home Manager configuration.

</div>

---

## Structure
> the structure is currently less modular than I would like, but it works for now. It's minimal.

| File | Purpose |
|------|---------|
| `flake.nix` | Flake inputs & outputs |
| `configuration.nix` | System-level NixOS config |
| `home.nix` | Home Manager config |
| `packages.nix` | Package list |
| `hardware-configuration.nix` | Hardware-specific settings |

## Apply

```sh
sudo nixos-rebuild switch --flake .#cybergaz # or change the hostname as needed
```

---

## Tips/Troubleshooting

- VIA keyboard recognition error: `chmod 777 /dev/hidraw1`
