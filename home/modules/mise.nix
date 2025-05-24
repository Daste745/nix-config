{
  # Still used in most of my projects for declarative tool management
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      status = {
        show_tools = true;
        show_env = true;
      };
      idiomatic_version_file_enable_tools = [ ];
    };
  };
}
