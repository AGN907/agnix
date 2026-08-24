let
  mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

  mkExtensionEntry =
    {
      id,
      pinned ? false,
    }:
    let
      base = {
        install_url = mkPluginUrl id;
        installation_mode = "force_installed";
      };
    in
    if pinned then base // { default_area = "navbar"; } else base;

  mkExtensionSettings = builtins.mapAttrs (
    _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
  );
in

{
  ExtensionSettings = mkExtensionSettings {
    "uBlock0@raymondhill.net" = mkExtensionEntry {
      id = "ublock-origin";
      pinned = true;
    };
    "clipper@obsidian.md" = mkExtensionEntry {
      id = "web-clipper-obsidian";
      pinned = true;
    };
    "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
    "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
    "{ef9e884b-b6d8-4544-b0de-82c46c5e95de}" = "sponsorblock";
    "{b2c364b8-0055-435f-afee-520d917ff521}" = "vicinae";
    "enhancerforyoutube@maximerf.addons.mozilla.org" = "enhancer-for-youtube";

  };
}
