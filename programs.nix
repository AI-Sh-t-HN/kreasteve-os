{ pkgs, lib, hermesDesktop, programProfile, programTable, ... }:

let
  rows = builtins.fromJSON (builtins.readFile programTable);
  selected = builtins.filter (row: row.${programProfile}) rows;
  favorites = builtins.filter (row: row."${programProfile} dock") selected;
  enabled = name: builtins.any (row: row.programm == name) selected;

  # Module-managed applications only need their desktop entry here.
  catalog = {
    Chromium = { package = pkgs.chromium; desktop = "chromium-browser.desktop"; };
    "Hermes Agent Desktop" = { package = hermesDesktop; desktop = "com.nousresearch.hermes.desktop"; };
    "Microsoft Visual Studio Code" = { package = pkgs.vscode; desktop = "code.desktop"; };
    OpenCode = { package = pkgs.opencode; desktop = "opencode.desktop"; };
    OrcaSlicer = { package = pkgs.orca-slicer; desktop = "OrcaSlicer.desktop"; };
    Podman = { package = pkgs.podman-desktop; desktop = "podman-desktop.desktop"; };
    Steam.desktop = "steam.desktop";
    "Windscribe (GUI)".desktop = "windscribe.desktop";
    Firefox.desktop = "firefox.desktop";
  };
  favoriteIds = map (row: catalog.${row.programm}.desktop) favorites;
in
{
  assertions = map (row: {
    assertion = builtins.hasAttr row.programm catalog;
    message = "Unbekanntes Programm in der Programmtabelle: ${row.programm}";
  }) rows;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfreePackages =
    lib.optional (enabled "Microsoft Visual Studio Code") "vscode"
    ++ lib.optionals (enabled "Steam") [ "steam" "steam-unwrapped" ];

  environment.systemPackages = lib.concatMap (row:
    lib.optional (catalog.${row.programm} ? package) catalog.${row.programm}.package
  ) selected ++ lib.optional (builtins.elem "opencode.desktop" favoriteIds) (pkgs.makeDesktopItem {
    name = "opencode";
    desktopName = "OpenCode";
    exec = "opencode";
    terminal = true;
  });

  services.desktopManager.gnome.favoriteAppsOverride = lib.mkForce ''
    [org.gnome.shell]
    favorite-apps=[${lib.concatMapStringsSep ", " (id: "'${id}'") favoriteIds}]
  '';

  programs.firefox.enable = enabled "Firefox";
  virtualisation.podman.enable = enabled "Podman";
  programs.steam.enable = enabled "Steam";
  services.windscribe = {
    enable = enabled "Windscribe (GUI)";
    variant = "gui";
  };
}
