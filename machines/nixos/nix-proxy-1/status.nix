{ ... }:
{
  homelab.services.gatus = {
    enable = true;
    endpoints = [
      {
        name = "Website";
        group = "Portfolio";
        url = "https://aleksanderbl.dk";
        interval = "5m";
        conditions = [ "[STATUS] == 200" ];
      }
      {
        name = "Dev website";
        group = "Portfolio";
        url = "https://dev.aleksanderbl.dk";
        interval = "5m";
        conditions = [ "[STATUS] == 200" ];
      }
      {
        name = "Website API";
        group = "Portfolio";
        url = "https://api.aleksanderbl.dk";
        interval = "5m";
        conditions = [ "[STATUS] == 200" ];
      }
      {
        name = "Hvem Vinder Valget";
        group = "Side Projects";
        url = "https://hvemvindervalget.dk";
        interval = "5m";
        conditions = [ "[STATUS] == 200" ];
      }
      {
        name = "dawaR";
        group = "rpkgs";
        url = "https://dawar.aleksanderbl.dk";
        interval = "5m";
        conditions = [ "[STATUS] == 200" ];
      }
      {
        name = "dkstat";
        group = "rpkgs";
        url = "https://ropengov.github.io/dkstat/";
        interval = "5m";
        conditions = [ "[STATUS] == 200" ];
      }
      {
        name = "geodk";
        group = "rpkgs";
        url = "https://ropengov.github.io/geodk/";
        interval = "5m";
        conditions = [ "[STATUS] == 200" ];
      }
    ];
  };
}
