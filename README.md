# Nix(OS) configuration

## Installation

TODO: Write install steps for nixos and other upcoming systems

## Secrets

Secrets are encrypted using [agenix](https://github.com/ryantm/agenix) and are decrypted during evaluation of a system.

### Add a new secret

[Tutorial](https://github.com/ryantm/agenix#tutorial)

```sh
cd secrets
# Add new entry in secrets.nix
agenix -e secret-name.age
```

### Re-key after adding new recipients to existing secrets

```sh
cd secrets
agenix --rekey
```
