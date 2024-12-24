{ pkgs, lib, inputs, devices, ... }:
{
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
  time.timeZone = "America/Miquelon";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "fr";
    useXkbConfig = true; # use xkb.options in tty.
  };
  users.users.root.initialPassword = "password";
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
    packages = with pkgs; [];
  };
  security.sudo.wheelNeedsPassword = false;
  networking = {
    hostName = "pixos";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = false;
      eth0.useDHCP = true;
    };
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    #nvd
  ];
  nix.settings = {
    trusted-users = [ "@wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
    keep-outputs = true;
    keep-derivations = true;
  };
  services.openssh.enable = true;

  #system.activationScripts.report-changes = ''
  #  PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
  #  nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  #'';

  raspberry-pi-nix = {
    board = "bcm2712";
    #kernel-version = "v6_10_12";
  };
  hardware = {
    bluetooth.enable = true;
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            BOOT_UART = {
              enable = false;
              value = 1;
            };
            uart_2ndstage = {
              enable = false;
              value = 1;
            };
            audio = {
              enable = true;
              value = "off";
            };
            sd_poll_once = {
              enable = true;
            };

            # NVME
            pciex1 = {
              enable = true;
            };
            pciex1_gen = {
              enable = true;
              value = 3;
            };
            nvme = {
              enable = true;
            };
          };
          dt-overlays = {
            vc4-kms-v3d-pi5 = {
              enable = true;
              params = { };
            };
            disable-bt = {
              enable = true;
              params = { };
            };
          };
          options = {
            hdmi_blanking = {
              enable = true;
              value = 1;
            };
            disable_overscan = {
              enable = true;
              value = 1;
            };
            gpu_mem_256 = {
              enable = true;
              value = 76;
            };
            gpu_mem_512 = {
              enable = true;
              value = 76;
            };
            gpu_mem_1024 = {
              enable = true;
              value = 76;
            };
            disable_splash = {
              enable = true;
              value = 1;
            };
#            enable_uart = {
#              enable = true;
#              value = 0;
#            };
            temp_limit = {
              enable = true;
              value = 75;
            };
            initial_turbo = {
              enable = true;
              value = 20;
            };
          };
        };
      };
    };
  };
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #};
  system.stateVersion = "24.11";
}
