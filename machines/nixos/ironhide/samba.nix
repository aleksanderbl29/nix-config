{ ... }:

{
  # Create media user and group
  users.groups.media = { };
  users.users.media = {
    isSystemUser = true;
    group = "media";
    description = "Media share user";
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "ironhide";
        "netbios name" = "ironhide";
        security = "user";
        "map to guest" = "bad user";
        "dns proxy" = "no";
        "hosts allow" = "127.0.0.1 192.168.0.0/16 10.0.0.0/8 192.168.20.0/24 100.64.0.0/10";
        "hosts deny" = "0.0.0.0/0";
        # macOS specific settings
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:model" = "MacSamba";
        "fruit:advertise_fullsync" = "true";
        "fruit:metadata" = "stream";
        "fruit:resource" = "stream";
        "fruit:posix_rename" = "true";
        "fruit:zero_file_id" = "true";
        "fruit:wipe_intentionally_left_blank_rfork" = "true";
        "fruit:delete_empty_adfiles" = "true";
        "ea support" = "yes";
        "inherit owner" = "yes";
        "inherit permissions" = "yes";
        "unix extensions" = "yes";
        "unix charset" = "UTF-8";
        "dos charset" = "CP932";
        # Disk space reporting settings
        "dfree command" = "/usr/bin/dfree";
        "dfree cache time" = "30";
      };
      private = {
        path = "/mnt/private";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "aleksander";
        "force group" = "users";
        # macOS specific share settings
        "fruit:time machine" = "yes";
        "fruit:time machine max size" = "107374182400"; # 100GB in bytes
        "vfs objects" = "catia fruit streams_xattr";
        "ea support" = "yes";
        "inherit owner" = "yes";
        "inherit permissions" = "yes";
      };
      media = {
        path = "/mnt/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "media";
        "force group" = "media";
        # macOS specific share settings
        # "fruit:time machine" = "yes";
        # "fruit:time machine max size" = "536870912000";  # 500GB in bytes
        "vfs objects" = "catia fruit streams_xattr";
        "ea support" = "yes";
        "inherit owner" = "yes";
        "inherit permissions" = "yes";
        # Media specific settings
        "valid users" = "media aleksander";
        "write list" = "media aleksander";
        "read list" = "media aleksander";
      };
    };
  };

  # Create necessary directories
  system.activationScripts.samba-dirs = ''
    mkdir -p /mnt/private
    mkdir -p /mnt/media
    chown -R aleksander:users /mnt/private
    chown -R media:media /mnt/media
    chmod 700 /mnt/private
    chmod 777 /mnt/media
  '';
}
