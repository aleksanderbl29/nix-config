{
  ...
}:
{
  # Tailscale
  services.tailscale = {
    enable = true;
    extraUpFlags = "--ssh";
  };
}
