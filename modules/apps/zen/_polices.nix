let
  extensions = import ./_extensions.nix;
in
{
  AllowFileSelectionDialogs = true;
  AutofilAddressEnabled = false;
  AutofilCreditCardEnabled = false;
  BackgroundAppUpdate = false;
  BlockAboutAddons = false;
  BlockAboutConfig = false;
  BlockAboutProfiles = false;
  DisableFirefoxAccounts = true;
  DisableFirefoxScreenshots = true;
  DisableFormHistory = true;
  DisablePocket = true;
  DontCheckDefaultBrowser = true;
  NoDefaultBookmarks = true;
  SanitizeOnShutdown = {
    FormData = true;
    Cache = true;
    Sessions = false;
    Cookies = false;
    History = false;
    SiteSettings = false;
    Locked = true;
  };
  HardwareAcceleration = true;
  ManualAppUpdateOnly = true;
  OfferToSaveLogins = false;
}
// extensions
