{ pkgs, hermesDesktop, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfreePackages = [ "vscode" "steam" "steam-unwrapped" ];

  environment.systemPackages = [
    pkgs.opencode
    pkgs.vscode
    hermesDesktop
    pkgs.orca-slicer
    pkgs.chromium
  ];

  virtualisation.podman.enable = true;
  programs.steam.enable = true;
  services.windscribe = {
    enable = true;
    variant = "gui";
  };
}
