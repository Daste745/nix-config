{ config, pkgs, ... }:
let
  inherit (config.xdg) stateHome;
in
{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    packageConfigurable = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.vim-darwin else pkgs.vim-full;
    extraConfig = ''
      " Disable compatibility with vi
      set nocompatible
      " Use 4-wide space tabs
      set shiftwidth=4
      " Tabs are 4-wide
      set tabstop=4
      " Use spaces instead of tabs
      set expandtab
      set smarttab
      " Auto indent
      set ai
      " Smart indent
      set si
      " Use system clipboard
      set clipboard^=unnamed

      " Highlight matching brackets
      " set showmatch
      " Search non-sensitively, unless capital chars are present
      set ignorecase
      set smartcase
      " Incremental search
      set incsearch
      " Command history
      set history=1000
      " Disable bells
      set noerrorbells
      set novisualbell
      set t_vb=
      set tm=500

      " Highlight syntax
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      set nobackup
      set nowb
      set noswapfile
      set viminfofile=${stateHome}/vim/viminfo
    '';
  };
}
