{ pkgs, ... }: {
  search = import ./_search.nix { inherit pkgs; };
  mods = import ./_mods.nix;
  spaces = import ./_spaces.nix;
  spacesForce = true;
  pins = import ./_pins.nix;
  pinsForce = true;
  presets.betterfox.enable = true;
  presets.arkenfox.enable = true;
  keyboardShortcutsVersion = 19;
  keyboardShortcuts = [
    {
      id = "zen-compact-mode-toggle";
      key = "c";
      modifiers = {
        control = true;
        alt = true;
      };
    }
    {
      id = "key_quitApplication";
      disabled = true;
    }
  ];

}
