let
  dataDir = "/var/lib/grimmory";
  booksDir = "/srv/media";
  gid = "1000";
  uid = "1000";
  port = 10001;
in
{
  nawa.services._.grimmory = {
    nixos = { config, pkgs, ... }: {
      sops.secrets."restic/grimmory" = { };
      sops.secrets.rclone = { };
      sops.secrets.grimmory_env = { };

      networking.firewall.allowedTCPPorts = [ port ];

      services.restic.backups.grimmory = {
        initialize = true;

        repository = "rclone:gdrive:grimmory-backups";

        passwordFile = config.sops.secrets."restic/grimmory".path;
        rcloneConfigFile = config.sops.secrets.rclone.path;

        paths = [
          "${dataDir}/mariadb/config"
          booksDir
        ];

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 12"
        ];
      };

      systemd.tmpfiles.rules = [
        "d ${dataDir}/mariadb/config 0755 1000 1000 -"
        "d ${dataDir}/data 0755 1000 1000 -"
        "d ${dataDir}/bookdrop 0755 1000 1000 -"
      ];

      systemd.services."docker-network-grimmory" = {
        path = [ pkgs.docker ];
        script = ''
          docker network inspect grimmory >/dev/null 2>&1 || docker network create grimmory
        '';
        wantedBy = [ "multi-user.target" ];
        before = [
          "docker-mariadb.service"
          "docker-grimmory.service"
        ];
      };

      virtualisation.oci-containers.backend = "docker";
      virtualisation.oci-containers.containers = {

        mariadb = {
          image = "lscr.io/linuxserver/mariadb:11.4.5";
          environmentFiles = [ config.sops.secrets.grimmory_env.path ];
          environment = {
            PUID = uid;
            PGID = gid;
            TZ = config.time.timeZone;
            MYSQL_DATABASE = "grimmory";
            MYSQL_USER = "grimmory";
          };
          volumes = [
            "${dataDir}/mariadb/config:/config"
          ];
          extraOptions = [
            "--network=grimmory"
            "--health-cmd=mariadb-admin ping -h localhost"
            "--health-interval=5s"
            "--health-timeout=5s"
            "--health-retries=10"
          ];
        };

        grimmory = {
          image = "grimmory/grimmory:v3.2.4 ";
          dependsOn = [ "mariadb" ];
          ports = [ "${toString port}:6060" ];
          environmentFiles = [ config.sops.secrets.grimmory_env.path ];
          environment = {
            USER_ID = uid;
            GROUP_ID = gid;
            TZ = config.time.timeZone;
            DATABASE_URL = "jdbc:mariadb://mariadb:3306/grimmory";
            DATABASE_USERNAME = "grimmory";
            BOOKLORE_PORT = "6060";
          };
          volumes = [
            "${dataDir}/data:/app/data"
            "${booksDir}:/books"
            "${dataDir}/bookdrop:/bookdrop"
          ];
          extraOptions = [ "--network=grimmory" ];
        };

      };
    };
  };
}
