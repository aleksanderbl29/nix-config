{ ... }:
let
  user = "aleksander";
in
{
  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };

  homebrew = {
    masApps = {
      "Fantastical" = 975937182;
      "Home Assistant" = 1099568401;
    };
    casks = [
      "visual-studio-code"
    ];
  #   brews = [
  #     "gcc"
  #   ];
  };
}