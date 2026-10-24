[
  (final: prev: {
    vim-full = prev.vim-full.override {
      luaSupport = false;
      perlSupport = false;
      pythonSupport = false;
      rubySupport = false;
    };
  })
]
