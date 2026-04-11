{ pkgs, fff-nvim, ... }:
{
  home.username = "gaz";
  home.homeDirectory = "/home/gaz";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # zip
    # xz
    # unzip
    # p7zip
    # oh-my-zsh
    # oh-my-posh
    # inputs.zen-browser.packages."${system}".twilight
    lyra-cursors
    bibata-cursors
    layan-gtk-theme
    kora-icon-theme
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
      # apparently this doesn't work, you have to set it in WM's config
      # name = "LyraB-cursors";
      # package = pkgs.lyra-cursors;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
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

  programs = {

    # basic configuration of git, please change to your own
    git = {
      enable = true;
      settings = {
        user = {
          name = "cybergaz";
          email = "kkanttechy@gmail.com";
        };
        init.defaultBranch = "master";
      };
    };

    # direnv
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    # obs-studio
    obs-studio.enable = true;

    neovim = {
      enable = true;
      plugins = [
        fff-nvim.packages.x86_64-linux.fff-nvim
      ];
    };

  };

  # home manager release version
  home.stateVersion = "25.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
