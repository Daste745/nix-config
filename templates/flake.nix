{
  description = "Custom flake templates";

  outputs =
    { self }:
    {
      templates = {
        dev-shell = {
          path = ./dev-shell;
          description = "Development shell for all systems";
        };
      };

      templates.default = self.templates.dev-shell;
    };
}
