{ pkgs, lib, ... }:
pkgs.rustPlatform.buildRustPackage {
  pname = "hypremoji";
  version = "1.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "Musagy";
    repo = "hypremoji";
    rev = "master";
    sha256 = "";
  };

  meta = with lib; {
    description = "Lightweight and fast emoji picker for the Hyprland window manager";
    homepage = "https://github.com/Musagy/hypremoji";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "hypremoji";
  };
}
