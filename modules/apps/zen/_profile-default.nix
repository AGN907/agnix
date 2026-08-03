{ pkgs, ... }: {
  search = import ./_search.nix { inherit pkgs; };
  mods = import ./_mods.nix;
  spaces = import ./_spaces.nix;
  spacesForce = true;
  presets.betterfox.enable = true;
  presets.arkenfox.enable = true;
  pins = {
    "Github" = {
      id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
      url = "https://github.com";
      position = 101;
    };
  };
  pinsForce = true;
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
