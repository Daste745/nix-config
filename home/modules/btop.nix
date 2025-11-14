{
  programs.btop = {
    enable = true;
    # https://github.com/aristocratos/btop#configurability
    settings = {
      theme_background = false;
      vim_keys = true;
      proc_gradient = false;
      proc_cpu_graphs = false;
    };
  };
}
