{ pkgs, lib, ... }:
pkgs.rustPlatform.buildRustPackage {
  pname = "hypremoji";
  version = "1.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "Musagy";
    repo = "hypremoji";
    rev = "master";
    sha256 = "sha256-IkpC/dXFxA4ZLLvJ1RaXGIR9qGf6yGhikokQGCqKBlE=";
  };

  cargoHash = "sha256-GbPWTi36s83TDEtg1+qO4uRCqKCmc6sY4PMXbEWMPQo=";
  cargoPatches = [
    ./add-Cargo.lock.patch
  ];

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    gtk4
    wl-clipboard # Needed?
    # FIXME: Still crashes at copy, even With wl-clipboard added
  ];

  doCheck = false; # Has no Rust-based tests

  postInstall = ''
    mkdir -p "$out/assets/"
    cp -r assets/* "$out/assets/"
  '';

  meta = with lib; {
    description = "Lightweight and fast emoji picker for the Hyprland window manager";
    homepage = "https://github.com/Musagy/hypremoji";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "hypremoji";
  };
}
