{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      username = {
        format = "[$user]($style)@";
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        trim_at = "";
        format = "[$hostname]($style) [$ssh_symbol]($style)in ";
      };
      status = {
        disabled = false;
        format = "[$status]($style) ";
      };
      git_commit.tag_disabled = false;
      git_metrics.disabled = false;
      direnv.disabled = false;
      nix_shell.symbol = "❄️ "; # Default has 2 spaces after the symbol
    };
  };
}
