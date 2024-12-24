#!/bin/sh

nix build '.#nixosConfigurations.pixos.config.system.build.sdImage'
