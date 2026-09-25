let
  dev-shell = {
    path = ./dev-shell;
    description = "Development shell for all systems";
  };
in
{
  inherit dev-shell;

  default = dev-shell;
}
