{ lib, ... }:
let
  noctalia =
    cmd:
    [
      "noctalia"
      "msg"
    ]
    ++ (lib.splitString " " cmd);
  vicinae = cmd: [ "vicinae" ] ++ (lib.splitString " " cmd);
in
{

  "Mod+Space".spawn = vicinae "toggle";
  "Mod+V".spawn = vicinae "vicinae://launch/clipboard/history";
  "Mod+Return".spawn = [
    "wezterm"
  ];
  "Mod+B".spawn = [
    "zen-beta"
  ];
  "Mod+Period".spawn = [ "localsend_app" ];
  "Mod+Comma".spawn = noctalia "settings-toggle";
  "Mod+S".spawn = noctalia "panel-toggle control-center";
  "Mod+M".spawn = noctalia "panel-toggle control-center system";
  "Mod+P".spawn = noctalia "panel-toggle session";
  "Mod+Alt+L".spawn = noctalia "session lock";
  "Mod+Alt+S".spawn = noctalia "session lock-and-suspend";
  "Print".spawn = noctalia "screenshot-region";
  "Ctrl+Print".spawn = noctalia "screenshot-fullscreen";
  "XF86AudioRaiseVolume".spawn = noctalia "volume-up";
  "XF86AudioLowerVolume".spawn = noctalia "volume-down";
  "XF86AudioMute".spawn = noctalia "volume-mute";
  "XF86MonBrightnessUp".spawn = noctalia "brightness-up";
  "XF86MonBrightnessDown".spawn = noctalia "brightness-down";

  "Mod+Q".close-window = { };
  "Mod+O".toggle-overview = { };
  "Mod+F".maximize-column = { };
  "Mod+Shift+F".fullscreen-window = { };
  "Mod+Shift+T".toggle-window-floating = { };
  "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
  "Mod+Shift+E".quit = _: {
    props.skip-confirmation = true;
  };
  # Focus Navigation
  "Mod+H".focus-column-left = { };
  "Mod+J".focus-window-or-workspace-down = { };
  "Mod+K".focus-window-or-workspace-up = { };
  "Mod+L".focus-column-right = { };
  # Window Movement
  "Mod+Shift+H".move-column-left = { };
  "Mod+Shift+J".move-window-down-or-to-workspace-down = { };
  "Mod+Shift+K".move-window-up-or-to-workspace-up = { };
  "Mod+Shift+L".move-column-right = { };
  # Workspace Navigation
  "Mod+U".focus-workspace-down = { };
  "Mod+I".focus-workspace-up = { };
  # Column Management
  "Mod+BracketLeft".consume-or-expel-window-left = { };
  "Mod+BracketRight".consume-or-expel-window-right = { };
  # Sizing & Layout
  "Mod+R".switch-preset-column-width = { };
  "Mod+Shift+R".switch-preset-window-height = { };
  "Mod+Ctrl+R".reset-window-height = { };
  "Mod+Minus".set-window-width = "-10%";
  "Mod+Shift+Minus".set-window-height = "-10%";
  "Mod+Equal".set-window-width = "+10%";
  "Mod+Shift+Equal".set-window-height = "+10%";
}
# Numeric Workspace Navigation
// builtins.foldl' (acc: elem: acc // elem) { } (
  map (i: {
    "Mod+${toString i}".focus-workspace = i;
    "Mod+Ctrl+${toString i}".move-column-to-workspace = i;
  }) (lib.genList (x: x) 10)
)
