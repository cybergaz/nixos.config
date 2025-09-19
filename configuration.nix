# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs;
      [
        vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
        # mesa
        # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
        # intel-media-sdk   # for older GPUs
      ];
  };

  # ------------------------------------------------------------------------
  # Swap and RAM management
  # ------------------------------------------------------------------------
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16 GB
  }];

  services.fstrim.enable = true;

  boot.kernelParams = [
    "i915.force_probe=46a8"
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # faster + efficient
    "zswap.max_pool_percent=20" # up to 25% of RAM for compressed pages
    # "zswap.zpool=z3fold" # 3 compressed pages per physical page frame.
  ];

  # ------------------------------------------------------------------------
  # Boot Loader
  # ------------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.plymouth.enable = true;

  # ------------------------------------------------------------------------
  # Networking
  # ------------------------------------------------------------------------
  networking = {
    # sshd.enable = true;
    hostName = "cybergaz";

    # wireless network interfaces.
    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      IPv6 = { Enabled = true; };
      Settings = { AutoConnect = true; };
    };

    # wired network interface. ( Replace enp0s20f0u5 with your interface name )
    # interfaces.enp0s20f0u5.useDHCP = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gaz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    # matrix || none
    animation = "matrix";
    # The character used to mask the password
    asterisk = ".";
    # Erase password input on failure
    clear_password = true;
    # Remove main box borders
    hide_borders = true;
    # Main box margins
    margin_box_h = 2;
    margin_box_v = 1;
    # Input boxes length
    input_len = 34;
  };

  virtualisation.docker.enable = true;

  programs.hyprland.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 2d --keep 2";
    # flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs;
    import ./packages.nix { inherit pkgs; };

  environment.localBinInPath = true;
  environment.variables = {
    # Set the default editor.
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    FILE_MANAGER = "nemo";
    OZONE_WL = "1"; # Enable ozone wayland support for chromium
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    PATH = "$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.bun/bin";
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    comfortaa
    jetbrains-mono
    nerd-fonts.noto
    noto-fonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # ------------------------------------------------------------------------
  # Power Management (laptop)
  # ------------------------------------------------------------------------
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      # list all modes -> 'cat /sys/devices/system/cpu/cpu0/cpufreq/*'
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandlePowerKey = "ignore";
        HandlePowerKeyLongPress = "poweroff";
        HandleSuspendKey = "ignore";
        HandleSuspendKeyLongPress = "hibernate";
      };
    };
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
