## pcscd-keep-alive

A systemd service that keeps pinging [pcscd]() every 4 seconds in order to
prevent shutdown. In practice, I use this with Yubikeys and
[age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey) to resolve
[PIN being requested all the time](https://github.com/str4d/age-plugin-yubikey/issues/144) issue.

Original python script by @LudovicRousseau from [here](https://github.com/str4d/age-plugin-yubikey/issues/144#issuecomment-1817814373)


### How to use

If you're on NixOS and on flakes, add this repo in your flake inputs:
``` nix
inputs.pcscd-keep-alive.url = github:supermarin/pcscd-keep-alive;
```

Then include the module:
``` nix
nixosConfigurations.computer = inputs.nixpkgs.lib.nixosSystem {
  modules = [
    inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
    # ...
  ];
  # ...
};
```

And in your configuration.nix:
``` nix
services.pcscd-keep-alive.enable = true;
```
