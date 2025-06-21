{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    includes = [
      "config.local"
    ];
  };
}
