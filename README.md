# Stevo Stack

Ein NixOS-Live-Image mit GNOME für Intel- und AMD-Rechner (x86_64). Dieselbe
ISO dient zum Ausprobieren in einer VM, zum Start vom USB-Stick und zur
grafischen Installation. Live und installiert stehen OpenCode (Terminal),
Podman, Microsoft Visual Studio Code, Hermes Agent Desktop, Windscribe (GUI),
Steam, OrcaSlicer und Chromium zur Verfügung.

## ISO bauen

Im Repository auf einem Linux-System mit x86_64-Builder und Nix ausführen:

```sh
nix --extra-experimental-features 'nix-command flakes' build '.#iso'
```

Die ISO liegt danach unter `result/iso/`. Die Datei `flake.lock` legt den
genauen Paketstand von NixOS 26.05 fest.

## Ausprobieren und installieren

- **VM:** Eine x86_64-VM anlegen, die ISO als virtuelles DVD-Laufwerk einlegen
  und davon booten. Für einen Installationstest eine leere virtuelle Festplatte
  hinzufügen.
- **USB-Stick:** Die ISO als Laufwerksabbild auf den Stick schreiben. Dabei
  werden vorhandene Daten auf dem ausgewählten Stick überschrieben. Den Stick
  anschließend im Bootmenü des Rechners auswählen.
- **GNOME testen:** Die Live-Sitzung startet ohne Installation mit deutscher
  Systemsprache (`de_DE.UTF-8`) und der Zeitzone `Europe/Berlin`. GNOME und die
  virtuelle Konsole verwenden das deutsche Tastaturlayout (`de`). Änderungen
  innerhalb der Live-Sitzung gehen beim Neustart verloren.
- **Installieren:** Eine Internetverbindung herstellen. In der GNOME-Übersicht
  **System installieren** öffnen. Im Installer Sprache, Tastaturlayout und
  Zeitzone für das Zielsystem prüfen, die Desktop-Auswahl auf GNOME lassen
  und den Zieldatenträger prüfen. „Unfreie Software erlauben“ ist vorausgewählt.
  Wer den Haken entfernt, erlaubt weiterhin die mitgelieferten Pakete für
  Steam und Visual Studio Code. Nach erfolgreicher Installation das Startmedium
  entfernen und vom Ziel booten.

Der VM-Test zur Vorauswahl für unfreie Software ist im [Testprotokoll](TESTPROTOKOLL.md) dokumentiert.

## Hardwarekonfiguration

Das Live-System erkennt die Geräte bei jedem Start. Bei der Installation
erzeugt Calamares im Zielsystem `/etc/nixos/hardware-configuration.nix` aus
der erkannten Hardware und den gewählten Dateisystemen. Die daneben erzeugte
`configuration.nix` enthält die Installationsauswahl einschließlich GNOME.
Calamares kopiert `flake.nix`, `flake.lock` und das gemeinsame Modul
`programs.nix` nach `/etc/nixos/` und verwendet diese Dateien bereits für
die Erstinstallation. Spätere Änderungen an der Programmliste lassen sich im
installierten System mit `sudo nixos-rebuild switch` übernehmen.

Hermes Agent Desktop stammt aus dem [Hermes-Projekt](https://github.com/NousResearch/hermes-agent).
Die offizielle Windscribe-GUI und ihren VPN-Hilfsdienst integriert das
[NixOS-Modul von ParkerrDev](https://github.com/ParkerrDev/nixpkgs-windscribe).
