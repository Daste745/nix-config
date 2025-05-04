# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          ({ pkgs, ... }: {
            system.stateVersion = "24.11";

            wsl = {
              enable = true;
              defaultUser = "stefan";
            };

            users.users.stefan = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              shell = pkgs.fish;
            };

            environment.systemPackages = with pkgs; [
              file
              tree
              wget
              htop
              fastfetch
              git
              nix-output-monitor
              gnupg
              ripgrep
            ];

            programs.fish.enable = true;
            programs.nix-ld.enable = true;  # For VSCode server on WSL

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.stefan = import ./home.nix;
            };

            nix = {
              settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              };
            };
          })
        ];
      };
    };
  };
}
