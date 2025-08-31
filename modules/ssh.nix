{ username, ... }:
{
  services.openssh = {
    enable = true;
    # NOTE)) Using extraConfig instead of settings for interoperability with nix-darwin
    extraConfig = ''
      PasswordAuthentication no
      PermitRootLogin no
      AllowUsers ${username}
    '';
  };
}
