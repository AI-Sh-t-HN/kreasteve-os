{ modulesPath, ... }:

{
  imports = [
    ./gnome.nix
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
  ];

  i18n.defaultLocale = "de_DE.UTF-8";
  services.xserver.xkb.layout = "de";
  console.useXkbConfig = true;
  time.timeZone = "Europe/Berlin";

  environment.etc."stevo/flake.nix".source = ./flake.nix;
  environment.etc."stevo/flake.lock".source = ./flake.lock;
  environment.etc."stevo/programs.nix".source = ./programs.nix;

  nixpkgs.overlays = [
    (_final: prev: {
      calamares-nixos-extensions = prev.calamares-nixos-extensions.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./calamares-install.patch ];
      });
    })
  ];

  # Erst den Desktop zeigen. Calamares bleibt über die GNOME-Übersicht erreichbar.
  environment.etc."xdg/autostart/calamares.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Calamares
    Hidden=true
  '';
}
