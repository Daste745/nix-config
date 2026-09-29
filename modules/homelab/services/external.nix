{
  homelab.dashboard.services = {
    nextcloud = {
      title = "Nextcloud";
      icon = "di:nextcloud";
      url = "cloud.kdng.net";
      # TODO)) alt-status-codes: [ 400 ]
      category = "Services";
    };
    syncthing = {
      title = "Syncthing";
      icon = "di:syncthing";
      url = "syncthing.kdng.net";
      category = "Services";
    };
    home-assistant = {
      title = "Home Assistant";
      icon = "di:home-assistant";
      url = "homeassistant.kdng.net";
      # check-url: https://homeassistant.kdng.net  # port 80 doesn't respond
      category = "Services";
    };
    transmission = {
      title = "Transmission";
      icon = "di:transmission";
      url = "transmission.kdng.net";
      category = "Services";
    };
    paperless = {
      title = "Paperless";
      icon = "di:paperless-ngx";
      url = "paperless.kdng.net";
      category = "Services";
    };

    truenas = {
      title = "TrueNAS";
      icon = "di:truenas";
      url = "192.168.1.100:81";
      protocol = "http";
      # allow-insecure = true;
      category = "Management";
    };
    nginx-proxy-manager = {
      title = "Nginx Proxy Manager";
      icon = "di:nginx-proxy-manager";
      url = "npm.kdng.net";
      category = "Management";
    };
    authelia = {
      title = "Authelia";
      icon = "di:authelia";
      url = "auth.kdng.net";
      category = "Management";
    };
    jetkvm = {
      title = "JetKVM";
      icon = "di:jetkvm";
      url = "jetkvm.kdng.net";
      protocol = "http";
      # allow-insecure = true;
      category = "Management";
    };
    unifi-router = {
      title = "Router";
      icon = "di:unifi";
      url = "192.168.1.1";
      protocol = "http";
      # allow-insecure = true;
      category = "Management";
    };

    immich = {
      title = "Immich";
      icon = "di:immich";
      url = "photos.kdng.net";
      category = "Media";
    };
    jellyfin = {
      title = "Jellyfin";
      icon = "di:jellyfin";
      url = "jellyfin.kdng.net";
      category = "Media";
    };
    kavita = {
      title = "Kavita";
      icon = "di:kavita";
      url = "kavita.kdng.net";
      category = "Media";
    };
    slskd = {
      title = "slskd";
      icon = "di:slskd";
      url = "slskd.kdng.net";
      category = "Media";
    };
    prowlarr = {
      title = "Prowlarr";
      icon = "di:prowlarr";
      url = "prowlarr.kdng.net";
      category = "Media";
    };
    metube = {
      title = "MeTube";
      icon = "di:metube";
      url = "metube.kdng.net";
      category = "Media";
    };
  };
}
