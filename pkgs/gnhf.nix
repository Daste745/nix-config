{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gnhf";
  version = "0.1.47";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kunchenguid";
    repo = "gnhf";
    tag = "gnhf-v${finalAttrs.version}";
    hash = "sha256-6XTluVmG7JVU8wOv3N+nc8/G1uwfPD5A3BmgjKLjGXg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_11
    pnpmConfigHook
    makeBinaryWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-kQHYvZ8LNHGw1pPuTnOTUn26yUY8TmgA0+BO2+cSvLY=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Drop dev dependencies so only the runtime closure is kept
    pnpm prune --prod --ignore-scripts

    mkdir -p $out/lib/gnhf
    # cli.mjs reads ../package.json (for --version), so package.json must be one level above dist/
    cp -r dist node_modules package.json skills $out/lib/gnhf/

    makeWrapper ${lib.getExe nodejs} $out/bin/gnhf \
      --add-flags $out/lib/gnhf/dist/cli.mjs

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Before I go to bed, I tell my agents: good night, have fun";
    homepage = "https://github.com/kunchenguid/gnhf";
    changelog = "https://github.com/kunchenguid/gnhf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gnhf";
    platforms = lib.platforms.all;
  };
})
