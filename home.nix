{ config, pkgs, system, inputs, ... }:

{
  home.username = "gaz";
  home.homeDirectory = "/home/gaz";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
      # zip
      # xz
      # unzip
      # p7zip
      # oh-my-zsh
      # oh-my-posh
      # inputs.zen-browser.packages."${system}".twilight
    ];

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "Jasper-Dark";
      package = pkgs.jasper-gtk-theme;
    };
    iconTheme = {
      name = "kora";
      package = pkgs.kora-icon-theme;
    };
    cursorTheme = {
      name = "LyraB-cursors";
      package = pkgs.lyra-cursors;
      size = 24;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Jasper-Dark";
        # cursor-theme = "LyraB-cursors";
        # icon-theme = "kora";
        # # font-name = "JetBrains Mono 10";
        # # monospace-font-name = "JetBrains Mono 10";
        # # show-battery-percentage = true;
        # enable-animations = true;
      };
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "cybergaz";
        email = "kkanttechy@gmail.com";
      };
      init.defaultBranch = "master";
    };
  };

  # Enable direnv
  programs = {
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };

  # home manager release version
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
