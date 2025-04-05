{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (_: prev: {
      vaapiIntel = prev.vaapiIntel.override { enableHybridCodec = true; };
    })
  ];

  # Hardware configuration for Intel N100
  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vaapiVdpau
        intel-compute-runtime
        vpl-gpu-rt
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Enable Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true; # Automatically open the required ports in the firewall
    user = "media";
    group = "media";
  };

  # Create Jellyfin user with proper group access
  # users.users.jellyfin = {
  #   isSystemUser = true;
  #   group = "jellyfin";
  #   extraGroups = [ "media" "users" ];
  # };
}
