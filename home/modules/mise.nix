{
  # Still used in most of my projects for declarative tool management
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    # https://mise.jdx.dev/configuration.html
    globalConfig = {
      settings = {
        idiomatic_version_file_enable_tools = [ ];
        status = {
          show_tools = true;
          show_env = true;
        };
      };
    };
  };
}
