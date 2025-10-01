{ lib, config, ... }:
{
  xdg.configFile."ideavim/ideavimrc" = lib.mkIf config.graphical.enable {
    text = ''
      set clipboard+=unnamedplus

      set highlightedyank
      set surround

      " Popup navigation (don't work)
      " inoremap <C-j> <action>(PopupMenu-selectNext)
      " inoremap <C-k> <action>(PopupMenu-selectPrev)

      " UI actions
      map gh <action>(ShowHoverInfo)
      map g. <action>(ShowIntentionActions)

      " Code actions
      nmap gd <action>(GotoDeclaration)
      nmap gt <action>(GotoTypeDeclaration)
      nmap gr <action>(ShowUsages)

      " Refactoring
      map cd <action>(RenameElement)
    '';
  };
}
