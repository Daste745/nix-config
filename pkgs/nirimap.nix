{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  gtk4-layer-shell,
  pango,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nirimap";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "alexandergknoll";
    repo = "nirimap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4HnmIc9FDXgPfbJdhjuVenc2R/wZ9ULTi6QaTskO1/s=";
  };

  cargoHash = "sha256-EI79WewUTAOFivRsR2ZjywEAYZ9Lq6YnfwPml071CqU=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    gtk4-layer-shell
    pango
  ];

  meta = {
    description = "A minimal workspace minimap overlay for the Niri Wayland compositor";
    homepage = "https://github.com/alexandergknoll/nirimap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nirimap";
  };
})
