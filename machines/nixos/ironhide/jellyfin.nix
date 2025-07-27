{ pkgs, ... }:

{
  nixpkgs.overlays = with pkgs; [
    (
      final: prev: {
        vaapiIntel = prev.vaapiIntel.override { enableHybridCodec = true; };
      }
    )
    (
      final: prev:
        {
          jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
            installPhase = ''
              runHook preInstall

              # this is the important line
              sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

              mkdir -p $out/share
              cp -a dist $out/share/jellyfin-web

              runHook postInstall
            '';
          });
        }
    )
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
    openFirewall = false; # Caddy handles external access via reverse proxy
    user = "media";
    group = "media";
  };

  # Enable homelab Jellyfin service for Caddy integration
  homelab.services.jellyfin.enable = true;

  # Disable until https://github.com/NixOS/nixpkgs/commit/c2450f04fb1b35b31980f8d8c05f42b5b51e1fa2 is in unstable
  # services.pinchflat = {
  #   enable = true;
  #   openFirewall = true;
  #   # secretsFile = ""
  #   selfhosted = true;
  #   mediaDir = "/mnt/media/pinchflat";
  #   user = "media";
  #   group = "media";
  # };
}
