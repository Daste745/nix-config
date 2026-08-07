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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "alexandergknoll";
    repo = "nirimap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U1F0IM4LmKBfMYx+qajyUgrN399xnvfa3y4Qdfet2SU=";
  };

  cargoHash = "sha256-53eSkxFF2nnEwavZutPeDQsABVyvKtArMUqsCHh7X7U=";

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
