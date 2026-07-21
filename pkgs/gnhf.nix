{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gnhf";
  version = "0.1.42";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kunchenguid";
    repo = "gnhf";
    tag = "gnhf-v${finalAttrs.version}";
    hash = "sha256-8dTfXCULAoXMJwb38bEMCazT7jzT130rzpLivVkx3Wc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-sqLCB3xSsd+eIbwFh2JrXUDYVt9Y5TCPKV5eBaBrZxs=";
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
