# NixOS on Raspberry Pi 5

A Nix Flake to build a NixOS image for RPI5.

## Usage

Build works on a NixOS system.

```sh
git clone https://github.com/darkone-linux/pixos.git
cd pixos
./build.sh
```

The RPI5 SD Image is in the `result` link, copy it to a SD Card (for example /dev/sda):

```sh
zstdcat -v result/sd-image/*.zst > /dev/sda
```

Boot and run in root:

```sh
nixos-generate-config
```

Configuration:

- Copy flake.nix and configuration.nix.
- Or create your own configuration.

## Sources

- [Raspberry PI Nix project](https://github.com/nix-community/raspberry-pi-nix) and [discussions](https://github.com/nix-community/raspberry-pi-nix/discussions)
- [This Flake example](https://github.com/tstat/raspberry-pi-nix-example/blob/master/flake.nix)
- And also thanks to Fez on Gaming Linux FR
