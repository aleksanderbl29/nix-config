{ ... }: {
  services.hyperhdr = {
    enable = true;
    config = {
      device = "/dev/ttyACM0";
      color = "rgb";
      priority = 50;
      effect = "Rainbow swirl fast";
    };
  };
}