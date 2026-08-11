let
  spaces = import ./_spaces.nix;

in
{
  pins = {
    "GMail" = {
      id = "be2f6dea-3c5b-4393-9508-36dac8e44742";
      workspace = spaces."Work".id;
      url = "https://mail.google.com";
      isEssential = true;
      position = 2;
    };
    "GitHub" = {
      id = "4caa5702-c88b-4efe-8de1-897f2a98c58a";
      workspace = spaces."Work".id;
      url = "https://github.com";
      isEssential = true;
      position = 3;
    };

    "Youtube" = {
      id = "31ae845a-108c-4afc-b128-e117804d509a";
      workspace = spaces."General".id;
      url = "https://www.youtube.com/";
      isEssential = true;
      position = 1;
    };
    "Reddit" = {
      id = "045be37d-59f0-4dcb-a764-82bbbd23ee5b";
      workspace = spaces."General".id;
      url = "https://www.reddit.com";
      isEssential = true;
      position = 2;
    };
  };
}
