{ pkgs, ... }:

with pkgs;
[
  git
  wget
  jq
  fd
  killall
  tmux
  reptyr

  # neovim
  tree-sitter

  openssl
  socat
  websocat
  whois
  dig
  pv
  pstree
  tmate

  alacritty
  waybar
  swayidle
  stasis
  libnotify
  libgcc
  libva-utils
  mako
  # dunst
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
  python315
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
  # nautilus
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
  onefetch
  awww
  viewnior
  dust
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
  # caligula # for usb flashing

  awscli2
  postgresql
  go
  code-cursor
  nil
  nixfmt

  telegram-desktop
  discord
  # postman
  obsidian
  pavucontrol
  spotify
  tigervnc

  wiremix
  impala
  bluetui

  # android mtp related stuff
  # ------------------------------------------------------------------------------------
  android-tools
  android-file-transfer # provides aft-mtp-mount
  # jmtpfs
  # gnome.gvfs
  libmtp # provides mtp-detect
  # ------------------------------------------------------------------------------------

  yt-dlp
]
