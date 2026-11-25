# Stevo Stack

Ein NixOS-Live-Image mit GNOME für Intel- und AMD-Rechner (x86_64). Dieselbe
ISO dient zum Ausprobieren in einer VM, zum Start vom USB-Stick und zur
grafischen Installation.

| Profil | Standardprogramme | GNOME-Dock in Reihenfolge |
| --- | --- | --- |
| Live | Chromium, Hermes Agent Desktop, VS Code, OpenCode (Terminal), Firefox, Element Desktop, Telegram Desktop | Chromium, VS Code, Firefox, Element Desktop, Telegram Desktop |
| Frische Installation | Alle Live-Programme sowie OrcaSlicer, Podman mit Podman Desktop, Steam und Windscribe (GUI) | Chromium, Hermes Agent Desktop, VS Code, Podman Desktop, Steam, Firefox, Element Desktop, Telegram Desktop |

Die [programme.xlsx](programme.xlsx) steuert beide Profile. Im ersten Blatt
die Werte `ja` oder `nein` für `live`, `fresh`, `live dock` und `fresh dock`
setzen und die ISO neu bauen. Die Zeilenreihenfolge bestimmt die Reihenfolge
der Favoriten. Neue Programmnamen brauchen eine Paketzuordnung in
`programs.nix`. Steve kann die Favoriten nach der Anmeldung in GNOME ändern.

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
  Zeitzone für das Zielsystem prüfen. GNOME ist fest eingestellt. Nach dem
  Anlegen des Benutzerkontos folgt direkt die Seite „Unfreie Software erlauben“
  mit vorausgewähltem Haken.
  Wer den Haken entfernt, erlaubt weiterhin die mitgelieferten Pakete für
  Steam und Visual Studio Code.
- **GNOME Extensions:** Vor der Zielauswahl lässt sich der installierte Desktop
  anpassen. Dock, durchsuchbare Zwischenablage, Statussymbole und Tiling
  Assistant sind vorausgewählt. Beim Zwischenablageverlauf bleiben nur
  angeheftete Texte über die Sitzung hinaus erhalten. Caffeine und GSConnect
  sind optional, weitere Erweiterungen lassen sich aufklappen. Die Vorgaben
  bleiben nach dem ersten Login änderbar.
- **Zielplatte einrichten:** „Festplatte löschen“, Swap für den Ruhezustand
  und LUKS2-Verschlüsselung sind vorausgewählt. Vor dem Bestätigen Modell
  und Größe der Zielplatte prüfen, besonders bei angeschlossenen USB-Platten.
  Die Installation löscht alle vorhandenen Daten auf dem gewählten Laufwerk.
  Die Partitionierung, die Swap-Auswahl und die Verschlüsselung lassen sich
  ändern. Bei aktivem LUKS die Passphrase zweimal eingeben und für spätere
  Starts aufbewahren. Im geführten UEFI-Layout sind System und Swap
  verschlüsselt, die EFI-Partition unter `/boot` bleibt lesbar.
- **Erster Start:** Nach erfolgreicher Installation das Startmedium entfernen
  und von der Zielplatte booten.

Die VM-Tests zum Installer und zu den Programmprofilen stehen im
[Testprotokoll](TESTPROTOKOLL.md).

## Hardwarekonfiguration

Das Live-System erkennt die Geräte bei jedem Start. Bei der Installation
erzeugt Calamares im Zielsystem `/etc/nixos/hardware-configuration.nix` aus
der erkannten Hardware und den gewählten Dateisystemen. Die daneben erzeugte
`configuration.nix` enthält die Installationsauswahl einschließlich GNOME.
Calamares kopiert `flake.nix`, `flake.lock`, `programs.nix` und die beim
ISO-Bau aus Excel erzeugte `programme.json` nach `/etc/nixos/`. Bereits die
Erstinstallation verwendet das Profil `fresh`. Der Installer legt außerdem
`gnome-extensions.nix`, den Katalog `gnome-extensions.json` und Steves
Auswahl in `selected-extensions.json` dort ab. Auf dem installierten Rechner
lassen sich die Auswahl in `/etc/nixos/programme.json` und die Paketzuordnungen
in `programs.nix` lokal ändern und mit `sudo nixos-rebuild switch` übernehmen.

Hermes Agent Desktop stammt aus dem [Hermes-Projekt](https://github.com/NousResearch/hermes-agent).
Die offizielle Windscribe-GUI und ihren VPN-Hilfsdienst integriert das
[NixOS-Modul von ParkerrDev](https://github.com/ParkerrDev/nixpkgs-windscribe).
