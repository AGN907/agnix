{ nawa, ... }:
{
  nawa.apps._.cli.provides = {
    full.includes = with nawa.apps._.cli._; [
      base
      rbw
    ];
    base.includes = with nawa.apps._.cli._; [
      atuin
      btop
      bat
      fzf
    ];
    base.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          aria2
          fd
          jq
          ripgrep
          wget
          imagemagick
          ffmpeg
          age
          xh
          yt-dlp
          dysk
          dust
          devenv
          hl-log-viewer
          just
          gomi
          chafa
          playerctl
          cliamp
        ];

        programs = {
          zoxide = {
            enable = true;
            enableFishIntegration = true;
          };
          eza = {
            enable = true;
            enableFishIntegration = true;
            git = true;
            colors = "always";
            icons = "always";
          };
          direnv = {
            enable = true;
            nix-direnv.enable = true;
            silent = true;
            config.global.warn_timeout = 0;
          };
          tealdeer = {
            enable = true;
            settings.updates.auto_update = true;
          };
        };
      };
    atuin.homeManager =
      { config, ... }:
      {
        sops.secrets.atuin_key = { };

        programs.atuin = {
          enable = true;
          flags = [ "--disable-up-arrow" ];
          enableFishIntegration = true;
          forceOverwriteSettings = true;
          settings = {
            dialect = "uk";
            sync_address = "https://api.atuin.sh";
            sync_frequency = "2h";
            enter_accept = true;
            key_path = config.sops.secrets.atuin_key.path;
            keymap-mode = "vim-normal";
            show_help = true;
            stats = {
              common_subcommands = [
                "cargo"
                "composer"
                "docker"
                "git"
                "npm"
                "pnpm"
                "systemctl"
                "zellij"
              ];
              ignored_commands = [
                "cd"
                "z"
                "ls"
                "vi"
              ];
            };
            sync.records = true;
            search.filters = [
              "global"
              "host"
              "session"
              "workspace"
              "directory"
            ];
            dotfiles.enabled = false;
          };
        };
      };
    btop.homeManager = {
      stylix.targets.btop.enable = true;
      programs.btop = {
        enable = true;
        settings = {
          vim_keys = true;
        };
      };
    };
    rbw.homeManager =
      { pkgs, ... }:
      {
        home.sessionVariables = {
          SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
        };

        home.packages = [ pkgs.pinentry-qt ];

        programs.rbw = {
          enable = true;
        };
      };
    bat.homeManager =
      { pkgs, ... }:
      {
        stylix.targets.bat.enable = true;
        programs.bat = {
          enable = true;
          config = {
            color = "always";
          };
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batgrep
          ];
        };
      };
    fzf.homeManager = { config, lib, ... }: {
      programs.fzf = {
        enable = true;
        enableFishIntegration = false;
        colors =
          with config.lib.stylix.colors.withHashtag;
          lib.mkForce {
            "bg" = base00;
            "bg+" = base02;
            "fg" = base05;
            "fg+" = base05;
            "header" = base0E;
            "hl" = base08;
            "hl+" = base08;
            "info" = base0A;
            "marker" = base06;
            "pointer" = base06;
            "prompt" = base0E;
            "spinner" = base06;
          };
      };
    };
  };
}
