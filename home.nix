{
  config,
  pkgs,
  inputs,
  # fff-nvim,
  ...
}:
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
    orchis-theme
    kora-icon-theme
  ];

  # GTK theming
  gtk = {
    enable = true;
    theme.name = "Orchis-Dark";
    iconTheme.name = "kora";
    cursorTheme = {
      # apparently this doesn't work, you have to set it in WM's config
      # name = "LyraB-cursors";
      # package = pkgs.lyra-cursors;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    gtk4.theme = null;
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Orchis-Dark";
        # cursor-theme = "LyraB-cursors";
        # icon-theme = "kora";
        # # font-name = "JetBrains Mono 10";
        # # monospace-font-name = "JetBrains Mono 10";
        # # show-battery-percentage = true;
        # enable-animations = true;
      };
    };
  };

  xdg.desktopEntries.alacritty-neovim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Edit text files";
    exec = "alacritty -t alacritty_float_wide -e nvim %F";
    icon = "nvim";
    terminal = false;
    categories = [
      "Utility"
      "TextEditor"
      "Development"
    ];
    mimeType = [
      "text/plain"
      "application/vnd.exstream-package"
      "text/english"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
    settings = {
      TryExec = "alacritty";
    };
  };

  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "inode/directory" = "nemo.desktop";
  #   };
  # };

  xdg.portal = {
    enable = true;

    config.niri = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
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
      # plugins = [
      #   fff-nvim.packages.x86_64-linux.fff-nvim
      # ];

      withRuby = false;
      withPython3 = false;

      # point HM at your actual config
      initLua = builtins.readFile ./nvim-init.hm-extra.lua;
    };

  };

  # Global cargo config, applies to every cargo build:
  # - link with mold (from modules/packages.nix)
  # - link against nix-ld's stable /lib64 loader instead of a /nix/store glibc
  #   path, so built binaries survive garbage collection. RUNPATH is dropped
  #   too, otherwise an old store glibc could get mixed with the current loader.
  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    rustflags = [
      "-C", "link-arg=-fuse-ld=mold",
      "-C", "link-arg=-Wl,--dynamic-linker=/lib64/ld-linux-x86-64.so.2",
    ]

    [env]
    NIX_DONT_SET_RPATH_x86_64_unknown_linux_gnu = "1"
  '';

  # home manager release version
  home.stateVersion = "25.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
