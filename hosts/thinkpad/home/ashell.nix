{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    # https://malpenzibo.github.io/ashell/docs/configuration
    settings = {
      enable_esc_key = true;
      language = "en-US";
      region = "pl-PL";
      appearance = {
        style = "Solid";
        font_name = "Maple Mono";
        scale_factor = 1.2;
      };
      modules = {
        left = [
          "Workspaces"
        ];
        center = [
          "WindowTitle"
        ];
        right = [
          "Tray"
          "SystemInfo"
          [
            "Tempo"
            "MediaPlayer"
            "Privacy"
            "Settings"
          ]
        ];
      };
      workspaces = {
        visibility_mode = "MonitorSpecific";
      };
      tempo = {
        weather_location = "Current";
      };
      media_player = {
        indicator_format = "Icon";
      };
      settings = {
        indicators = [
          "IdleInhibitor"
          "PowerProfile"
          "Audio"
          "Microphone"
          "Bluetooth"
          "Network"
          "Vpn"
          "Battery"
          "PeripheralBattery"
          "Brightness"
        ];

        remove_airplane_btn = true;

        lock_cmd = "swaylock &";
        audio_sinks_more_cmd = "pavucontrol -t 3";
        audio_sources_more_cmd = "pavucontrol -t 4";
        wifi_more_cmd = "nm-connection-editor";
        vpn_more_cmd = "nm-connection-editor";
        bluetooth_more_cmd = "blueman-manager";
      };
    };
  };
}
