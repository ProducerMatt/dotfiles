{
  services.ollama = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    # # CPU acceleration
    # acceleration = false;
  };
}