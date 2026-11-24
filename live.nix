{ modulesPath, pkgs, lib, ... }:

let
  python = pkgs.python3.withPackages (p: [ p.openpyxl ]);
  programTable = pkgs.runCommand "programme.json" { } ''
    ${python}/bin/python - ${./programme.xlsx} > "$out" <<'PYTHON'
    import json
    import sys
    from openpyxl import load_workbook

    workbook = load_workbook(sys.argv[1], read_only=True, data_only=True)
    rows = iter(workbook.worksheets[0].values)
    header = list(next(rows))
    columns = ["programm", "live", "fresh", "live dock", "fresh dock"]
    if header != columns:
        raise ValueError(f"Erwartete Spalten: {columns}")
    result = []
    seen = set()
    for index, values in enumerate(rows, start=2):
        if all(value is None for value in values):
            continue
        name, *flags = values
        if not name or name in seen or any(flag not in ("ja", "nein") for flag in flags):
            raise ValueError(f"Programm oder ja/nein-Wert in Zeile {index} prüfen")
        seen.add(name)
        row = dict(zip(columns[1:], (flag == "ja" for flag in flags), strict=True))
        for profile in ("live", "fresh"):
            if row[profile + " dock"] and not row[profile]:
                raise ValueError(f"Dock-Eintrag für abgewähltes Programm: {name} ({profile})")
        result.append({"programm": name, **row})
    json.dump(result, sys.stdout, ensure_ascii=False, indent=2)
    PYTHON
  '';
in
{
  imports = [
    # Firefox is managed by the workbook, including on the upstream graphical ISO.
    { options.environment.defaultPackages = lib.mkOption {
        apply = builtins.filter (package: package != pkgs.firefox);
      };
    }
    ./gnome.nix
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
  ];

  i18n.defaultLocale = "de_DE.UTF-8";
  services.xserver.xkb.layout = "de";
  console.useXkbConfig = true;
  time.timeZone = "Europe/Berlin";

  _module.args.programTable = programTable;
  environment.etc."stevo/programme.json".source = programTable;
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
