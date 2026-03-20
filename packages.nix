{ pkgs, ... }:

with pkgs;
[
  git
  wget
  jq
  fd
  killall
  tmux

  neovim
  # tree-sitter

  openssl
  websocat
  whois
  dig
  pv
  pstree
  tmate

  alacritty
  waybar
  swayidle
  libnotify
  libgcc
  mako
  ly
  firefox-bin
  google-chrome
  wofi
  btop
  lazygit
  # rustup
  zig
  bun
  nodejs
  fzf
  unrar
  zip
  unzip
  ripunzip
  ripgrep
  bat
  eza
  xcp
  gcc
  gnumake
  wl-clipboard
  cliphist
  iwgtk
  nemo
  brightnessctl
  hyprlock
  hyprpicker
  xwayland-satellite
  grim
  slurp
  cloudflare-warp
  zoxide
  mpv
  fastfetch
  swww
  viewnior
  dust
  gnome.gvfs
  aria2
  usbutils
  pkg-config
  mold
  clang
  # fast-cli
  playerctl
  ffmpeg
  ncdu
  nvtopPackages.intel

  awscli2
  postgresql
  go
  code-cursor
  nil
  nixfmt

  telegram-desktop
  discord
  postman
  obsidian
  pavucontrol
  spotify
]
