# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
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
              vim
              wget
              htop
              fastfetch
              git
              tmux
              direnv
            ];

            programs.fish.enable = true;

            nix = {
              settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              };
            };
          })
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.backupFileExtension = "backup";
          #   home-manager.users.stefan = /home/stefan/.nix-config/home.nix;
          # }
        ];
      };
    };
  };
}
