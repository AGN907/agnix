{ pkgs, ... }: {
  search = import ./_search.nix { inherit pkgs; };
  mods = import ./_mods.nix;
  spaces = import ./_spaces.nix;
  spacesForce = true;
  presets.betterfox.enable = true;
  keyboardShortcutsVersion = 20;
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
