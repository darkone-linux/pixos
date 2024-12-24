# This is the SD image initial configuration

{ pkgs, lib, inputs, devices, ... }:
{
  # Comment this line if you want a recent kernel, but 
  # if it's not in the community cache the builder will compile it
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;

  # Initial TimeZone + keyboard
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "en";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Initial users configuration
  users.users.root.initialPassword = "password";
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
    packages = with pkgs; [];
  };
  security.sudo.wheelNeedsPassword = false;

  # Initial network configuration
  networking = {
    hostName = "pixos";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = false;
      eth0.useDHCP = true;
    };
  };

  # Some programs
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
  ];

  # Experimental features must be activated
  nix.settings = {
    trusted-users = [ "@wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
    keep-outputs = true;
    keep-derivations = true;
  };

  # Access via SSH
  services.openssh.enable = true;

  # The board and wanted kernel version
  raspberry-pi-nix = {
    board = "bcm2712";
    #kernel-version = "v6_10_12";
  };

  # PI Hardware configuration
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

            # NVME disk access
            #pciex1 = {
            #  enable = true;
            #};
            #pciex1_gen = {
            #  enable = true;
            #  value = 3;
            #};
            #nvme = {
            #  enable = true;
            #};

          };
          dt-overlays = {
            vc4-kms-v3d-pi5 = {
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

  # You can put another features here, for example:
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #};

  # DO NOT TOUCH THIS
  system.stateVersion = "24.11";
}
