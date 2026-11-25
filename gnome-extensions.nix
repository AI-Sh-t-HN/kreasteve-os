{ pkgs, lib, ... }:

let
  catalog = lib.importJSON ./gnome-extensions.json;
  selection = lib.importJSON ./selected-extensions.json;
  layoutIds = map (row: row.id) (builtins.filter (row: row.group or "" == "layout") catalog);
  ids = builtins.filter (id: id != "standard") selection;
  packages = pkgs.gnomeExtensions // {
    # Version 71 appends the newest item after filtering the history to favorites.
    clipboard-indicator = pkgs.gnomeExtensions.clipboard-indicator.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace extension.js \
          --replace-fail '.concat([entry]);' '.concat(CACHE_ONLY_FAVORITE && !entry.isFavorite() ? [] : [entry]);'
      '';
    });
    extension-list = pkgs.gnomeExtensions.extension-list.overrideAttrs (old: {
      version = "45";
      src = pkgs.fetchurl {
        url = "https://extensions.gnome.org/extension-data/extension-listtu.berry.v45.shell-extension.zip";
        hash = "sha256-0COeGlJp3EZuZSxQlvWr5NNghxLBTcLCr0jwNYW0zgs=";
      };
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.unzip ];
      sourceRoot = ".";
    });
  };
in
{
  assertions = [{
    assertion = builtins.all (id: builtins.elem id (map (row: row.id) catalog)) selection
      && builtins.length (lib.intersectLists layoutIds selection) == 1
      && lib.unique selection == selection;
    message = "Die GNOME-Auswahl muss genau ein Layout und gültige, eindeutige Optionen enthalten.";
  }];

  environment.systemPackages = map (id: packages.${id}) ids;
  programs.kdeconnect = lib.mkIf (builtins.elem "gsconnect" ids) {
    enable = true;
    package = packages.gsconnect;
  };

  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/shell".enabled-extensions =
        if ids == [ ] then lib.gvariant.mkEmptyArray lib.gvariant.type.string
        else map (id: packages.${id}.extensionUuid) ids;
    } // lib.optionalAttrs (builtins.elem "clipboard-indicator" ids) {
      "org/gnome/shell/extensions/clipboard-indicator" = {
        display-mode = lib.gvariant.mkInt32 0;
        cache-only-favorites = true;
        cache-images = false;
      };
    };
  }];
}
