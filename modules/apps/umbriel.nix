{ inputs, ... }: {
  flake-file.inputs.umbriel.url = "git+https://github.com/noctalia-dev/umbriel";

  nawa.apps._.umbriel = {
    nixos = {
      imports = [ inputs.umbriel.nixosModules.default ];
      programs.umbriel.enable = true;
    };

    homeManager = { config, ... }: {
      imports = [ inputs.umbriel.homeModules.default ];
      programs.umbriel = {
        enable = true;
        settings =
          let
            colors = config.lib.stylix.colors.withHashtag;
          in
          {
            general = {
              autostart = [
                "noctalia"
                "localsend_app"
              ];
              mod_key = "Super";
            };
            layout = {
              gap = 5;
              width_presets = [
                0.25
                0.50
                0.75
                1
              ];
            };
            input = {
              keyboard.layout = "us,ara";
              cursor.hardware_cursor = false;
            };
            environment = {
              GTK_THEME = "adw-gtk3";
              QT_QPA_PLATFORMTHEME = "qt6ct";
            };
            keybinds = {
              # Umbriel
              "Mod+Q" = "window-close";
              "Mod+E" = "session-quit";
              "Mod+O" = "overview-toggle";
              "Mod+Shift+K" = "keyboard-layout-next";
              "Mod+T" = "window-toggle-floating";

              # Noctalia
              "Mod+S" = "spawn:noctalia msg panel-toggle settings-toggle";
              "Mod+P" = "spawn:noctalia msg screenshot-region";
              "Mod+Shift+P" = "spawn:noctalia msg screenshot-fullscreen";
              "Mod+Escape" = "spawn:noctalia msg panel-toggle session";
              "Mod+W" = "spawn:noctalia msg panel-toggle wallpaper";
              "Mod+Shift+W" = "spawn:noctalia msg panel-toggle noctalia/wallhaven:browser";

              # Apps
              "Mod+Return" = "spawn:wezterm";
              "Mod" = "spawn:vicinae toggle";
              "Mod+V" = "spawn:vicinae vicinae://launch/clipboard/history";
              "Mod+B" = "spawn:zen-beta";

              # Windows and workspaces
              "Mod+H" = "window-focus-left";
              "Mod+J" = "window-focus-or-workspace-up";
              "Mod+K" = "window-focus-or-workspace-down";
              "Mod+L" = "window-focus-right";

              "Mod+Shift+H" = "column-move-left";
              "Mod+Shift+L" = "column-move-right";

              "Mod+Comma" = "workspace-previous";
              "Mod+Period" = "workspace-next";
              "Mod+Shift+Comma" = "window-move-to-workspace-previous";
              "Mod+Shift+Period" = "window-move-to-workspace-next";

              "Mod+R" = "window-cycle-width";
              "Mod+C" = "column-center";
              "Mod+Shift+C" = "window-center";
              "Mod+F" = "window-toggle-maximize";
              "Mod+Shift+F" = "window-toggle-fullscreen";
              "Mod+Minus" = "window-modify-width:-0.1";
              "Mod+Equal" = "window-modify-width:+0.1";
              "Mod+BracketLeft" = "window-consume-left";
              "Mod+BracketRight" = "window-expel-right";

              # Volume
              "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
              "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
              "Mod+XF86AudioMute" = "spawn:noctalia msg volume-mute";

              # Media playback (playerctl)
              "XF86AudioPlay" = "spawn:playerctl play-pause";
              "XF86AudioNext" = "spawn:playerctl next";
              "XF86AudioPrev" = "spawn:playerctl previous";

              # Brightness
              "XF86MonBrightnessUp" = "spawn:noctalia msg brightness-up";
              "XF86MonBrightnessDown" = "spawn:noctalia msg brightness-down";
            };
            window_rule = [
              {
                blur = true;
                blur_optimized = true;
              }
              {
                match.app_id = "^(org.wezfurlong.wezterm)$";
                default_width = 0.50;
              }
              {
                match.app_id = "^(zen-beta)$";
                default_width = 0.75;
              }
              {
                match.app_id = "^(xdg-desktop-portal|org\\.pulseaudio\\.pavucontrol|localsend_app)$";
                default_floating = true;
              }
              {
                match.title = "^(Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)";
                default_floating = true;
              }
              {
                match.app_id = "^dev.noctalia.Noctalia$";
                default_floating = true;
                default_size = [
                  1020
                  900
                ];
                blur_popups = false;
              }
              {
                match.app_id = "^dev.noctalia.UmbrielSharePicker$";
                default_floating = true;
                default_size = [
                  800
                  600
                ];
                default_position = {
                  x = 32;
                  y = 32;
                  anchor = "bottom_right";
                };
              }
              {
                match.title = "^(vi|vim)$";
                opacity = 0.97;
              }
              {
                match.is_focused = false;
                opacity = 0.85;
              }
            ];
            layer_rule = [
              {
                match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
                blur = true;
                blur_ignore_alpha = 0.5;
                blur_popups = true;
              }
            ];
            appearance = {
              border_width = 1;
              border_focused = colors.base0D;
              border_unfocused = colors.base03;
            };
            colors = {
              background = colors.base00;
              text_primary = colors.base05;
              text_muted = colors.base05;
              accent_primary = colors.base0C;
              accent_secondary = colors.base0E;
              warning = colors.base0A;
              error = colors.base08;
            };
          };

      };
    };
  };
}
