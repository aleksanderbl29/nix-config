{ config, lib, ... }:
let
  cfg = config.homelab.services.littlelink;
  homelab = config.homelab;
in
{
  options.homelab.services.littlelink = {
    enable = lib.mkEnableOption "Littlelink personal links page";

    url = lib.mkOption {
      type = lib.types.str;
      default = "links.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8089;
      description = "External port where Littlelink is accessible";
    };

    containerPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Internal container port";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Links";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Personal links and social media page";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "littlelink.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Personal";
    };
  };

  config = lib.mkIf cfg.enable {
    # Configure Docker container
    virtualisation.oci-containers.containers.littlelink-server = {
      image = "ghcr.io/techno-tim/littlelink-server:latest";
      ports = [
        "${toString cfg.port}:${toString cfg.containerPort}/tcp"
      ];
      environment = {
        "AVATAR_2X_URL" = "https://pbs.twimg.com/profile_images/1661137669156487168/VcAtkav1_400x400.jpg";
        "AVATAR_ALT" = "Aleksander's profile pic";
        "AVATAR_URL" = "https://pbs.twimg.com/profile_images/1661137669156487168/VcAtkav1_400x400.jpg";
        "BIO" = "Hey! Find mig disse steder!";
        "BLUESKY" = "https://bsky.app/profile/aleksanderbl.dk";
        "BUTTON_ORDER" = "TWITTER,BLUESKY,GITHUB,INSTAGRAM,LINKED_IN,CV,EMAIL";
        "CUSTOM_BUTTON_ALT_TEXT" = "My CV,Min R-pakke";
        "CUSTOM_BUTTON_COLOR" = "#000000,#2568BD";
        "CUSTOM_BUTTON_ICON" = "fas file-alt,fas box";
        "CUSTOM_BUTTON_NAME" = "CV,R-pakke";
        "CUSTOM_BUTTON_TEXT" = "CV";
        "CUSTOM_BUTTON_TEXT_COLOR" = "#ffffff,#ffffff";
        "CUSTOM_BUTTON_URL" = "https://cv.aleksanderbl.dk,https://package.aleksanderbl.dk";
        "EMAIL" = "kontakt@aleksanderbl.dk";
        "EMAIL_TEXT" = "Send mig en mail!";
        "FAVICON_URL" = "https://pbs.twimg.com/profile_images/1661137669156487168/VcAtkav1_400x400.jpg";
        "FOOTER" = "Aleksander Bang-Larsen © 2024";
        "GITHUB" = "https://github.com/aleksanderbl29";
        "LINKED_IN" = "https://www.linkedin.com/in/aleksander-bang-larsen-405b03a4/";
        "META_AUTHOR" = "Aleksander Bang-Larsen";
        "META_DESCRIPTION" = "Aleksanders små links";
        "META_TITLE" = "Aleksander's links";
        "NAME" = "Aleksander's links";
        "SKIP_HEALTH_CHECK_LOGS" = "true";
        "THEME" = "Dark";
        "TWITTER" = "https://twitter.com/bang_aleksander";
      };
      extraOptions = [
        "--hostname=littlelink-server"
        "--security-opt=no-new-privileges:true"
      ];
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
