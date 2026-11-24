# Änderungskatalog für Installer und Desktop

Wir prüfen Vorschläge anhand der vorhandenen NixOS- und Calamares-Konfiguration.
Wenn mehrere Varianten infrage kommen, halten wir die Entscheidung nach der
Abstimmung fest. Die Umsetzung beginnt auf gesonderten Auftrag.

## Beschlossen

- **Standardprogramme** – Die [programme.xlsx](programme.xlsx) ist vorerst
  die maßgebliche Quelle für die gewünschte Programmauswahl. Die Spalten
  `live` und `fresh` legen die Programme für das Live-System und die frische
  Installation fest. `live dock` und `fresh dock` bestimmen die jeweiligen
  Dock-Favoriten.
- **Desktop** – Der Installer überspringt die Desktop-Auswahl und setzt
  GNOME als Standard für das installierte System.
- **Unfreie Software** – Der Installer erlaubt unfreie Software standardmäßig
  im Zielsystem. Die bisherige Auswahl wird durch eine reine Hinweisseite
  ersetzt. Sie erklärt kurz den Grund. Mit „Weiter“ geht die Installation
  weiter, ohne dass eine Auswahl erforderlich ist.

Textvorschlag für die Hinweisseite:

> Dieses System erlaubt unfreie Software, damit Programme wie Steam und
> Visual Studio Code vorinstalliert sind und du bei Bedarf proprietäre
> Treiber installieren kannst.

### Auswahlseiten für optionale Funktionen

Der Installer soll zwei Seiten anbieten. Jede Option erhält eine kurze
Beschreibung, damit Steve entscheiden kann, was er im Zielsystem nutzen möchte.

1. **GNOME Extensions** – Auswahl von Desktop-Erweiterungen, etwa einem
   Verlauf für die Zwischenablage.
2. **KI** – Auswahl lokaler KI-Funktionen. Kandidaten sind Diktieren per
   Tastenkürzel mit Whisper und das Vorlesen von Texten. Für das Diktat ist
   automatische CUDA-Beschleunigung auf geeigneten NVIDIA-GPUs mit einer
   CPU-Variante für andere Rechner und VMs vorgeschlagen.

Die konkreten Optionen und ihre Vorauswahl bleiben offen.

## Wichtig

### NVIDIA auf echter Hardware und GNOME in der VM

GPU-Modell und Bauform von Steves Rechner sind unbekannt. Der Live-Stick soll
auf dem Rechner und in der VM einen benutzbaren GNOME-Desktop starten. Volle
NVIDIA-Beschleunigung mit dem offiziellen Treiber ist erst im installierten
System vorgesehen. Steam kann aus dem Live-System entfallen und soll im
installierten System verfügbar bleiben. Die Größenersparnis ist offen.

Die Wahl des Treiberzweigs hängt von der erkannten GPU ab. Die offenen
Kernelmodule von NVIDIA unterstützen Turing und neuere GPUs. Für die Abnahme
ein Steam-Spiel und das Aufwachen aus dem Ruhezustand auf echter Hardware
prüfen. Die VM separat mit virtueller Grafik starten.
[NVIDIA zu unterstützten GPU-Generationen](https://download.nvidia.com/XFree86/Linux-x86_64/570.181/README/kernel_open.html)

### Geführte Verschlüsselung der internen Zielplatte

Beschlossen ist die gesamte interne Zielplatte als Standard, mit Swap für
Ruhezustand und vorausgewähltem LUKS2 für System, Benutzerdaten und Swap.
Steve kann die Partitionierung ändern, eine andere Swap-Option wählen und
LUKS abwählen. Bei aktivem LUKS gibt er seine Passphrase zweimal ein. Die
Ziellaufwerksauswahl und die Bestätigung vor dem Löschen bleiben sichtbar,
auch wenn das externe Steam-Laufwerk angeschlossen ist. Beim vorhandenen
UEFI-Layout bleibt die EFI-Systempartition unter `/boot` lesbar.

Calamares kennt dafür `initialPartitioningChoice: erase`,
`initialSwapChoice: suspend` und `preCheckEncryption: true`. Der Installer
muss das installierte System auch für die Wiederaufnahme einrichten. Bei
aktivem LUKS muss der verschlüsselte Swap beim nächsten Start wieder
entsperrbar sein. Abnahme in der VM mit und ohne LUKS: Layout kontrollieren,
ohne ISO starten und nach echtem Ruhezustand dieselbe Sitzung fortsetzen.
[Calamares-Partitionsmodul](https://codeberg.org/Calamares/calamares/src/branch/calamares/src/modules/partition/partition.conf)

Textvorschlag für die Partitionierungsseite:

> Die Standardauswahl löscht alle Daten auf dem ausgewählten Laufwerk.
> Prüfe vor dem Installieren den Namen und die Größe des Laufwerks.
> Die Verschlüsselung schützt deine Dateien und die im Ruhezustand
> gespeicherte Sitzung. Wähle eine Passphrase, die du beim Start eingeben
> kannst, und bewahre sie sicher auf. Du kannst die Verschlüsselung abwählen.

## Nice to have

### Startbare Wiederherstellung auf der internen Platte (niedrige Priorität)

Steve soll das installierte System aus dem Bootmenü auf den Zustand der
Erstinstallation zurücksetzen können. Seine persönlichen Dateien bleiben
dabei erhalten.

Calamares kann im geführten Layout eine zusätzliche Partition anlegen.
Das Projekt könnte sie während der Installation mit einem eigenen kleinen
Rettungssystem befüllen und einen Eintrag „System reparieren“ im Bootmenü
anlegen. Dafür müssten wir Rettungsimage, Startpfad und Reparaturablauf
bauen und pflegen. Die Partition braucht Platz auf dem Zielrechner. Der
USB-Stick wächst um zusätzlich mitgelieferte Rettungsinhalte.

Offen bleibt, ob auch Einstellungen, Browserprofile, Spielstände und
Schlüsselbund erhalten bleiben sollen und ob die Wiederherstellung ohne
Internet funktionieren soll.

[NixOS-Handbuch zu Generationen und Reparatur vom Installationsmedium](https://nixos.org/manual/nixos/stable/)

### Desktop und Anwendungen

| Wunsch | Aufwand und offene Entscheidung |
| --- | --- |
| GNOME-Pakete aus der frischen Installation entfernen | Klein für einzelne Apps. Vorab die doppelten Anwendungen benennen und pro Aufgabe festlegen, welche Steve behalten möchte. Eine Änderung nur im Zielsystem spart keinen Platz auf dem Live-Stick. |
| Clipboard-History und weitere GNOME-Erweiterungen | Klein bis mittel. Paket und Aktivierung für den ersten Login einplanen. Für die Zwischenablage klären, ob der Verlauf eine Abmeldung überdauern soll und wie kopierte Zugangsdaten behandelt werden. Kompatibilität bei GNOME-Upgrades prüfen. [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/) |
| Änderbare Hotkeys | Klein für vorhandene Aktionen. Gewünschte Tasten mit bestehenden Belegungen abgleichen. Beispielsweise öffnet Super+V unter GNOME bereits die Benachrichtigungen. [GNOME-Tastenkürzel](https://help.gnome.org/gnome-help/shell-keyboard-shortcuts) |
| Lokales Diktat mit CUDA und Hotkey, eventuell TTS | Mittel bis hoch. `whisper.cpp` ist ein Kandidat für deutsche Transkription. Aufnahme starten und stoppen, Ziel des Textes und Verhalten ohne NVIDIA festlegen. Vorlesen benötigt eine Sprachsynthese mit passender Stimme. Modell im Image oder Download beim ersten Einsatz ist eine eigene Entscheidung. [whisper.cpp](https://github.com/ggml-org/whisper.cpp) |
| Steam-Bibliothek auf externer NTFS-Platte | Mittel für einen festen Einhängepfad und einmaliges Hinzufügen in Steam. Automatische Erkennung und funktionierende Proton-Spiele brauchen Tests mit Steves Bibliothek. Das Community-Wiki im Proton-Projekt beschreibt den Betrieb als nicht unterstützt. Weiternutzung unter Windows und zwei konkrete Testspiele klären. [Proton-Wiki zu NTFS](https://github.com/ValveSoftware/Proton/wiki/Using-a-NTFS-disk-with-Linux-and-Windows) |
| Begrüßung nach dem ersten Login | Klein für eine eigene einmalige Willkommensseite, höher für Änderungen an GNOME Tour samt Pflege bei Updates. Inhalte und gewünschte Aktionen entscheiden über die Variante. [GNOME Tour](https://apps.gnome.org/Tour/) |

## Experimente mit niedriger Priorität

- **Wallpaper für Live-System und Installation** – Geringer Aufwand für eine
  vorhandene Bilddatei als änderbaren Standard. Motiv, Auflösung und Varianten
  für helles und dunkles Design sind offen.
- **Agentengesteuertes Erstsetup mit Pi oder Hermes** – Aufwand abhängig von
  den Aufgaben. Als ersten Versuch eine konkrete wiederholbare Aktion wählen.
  Vorher festlegen, was nach Eingabe des Inference-Keys automatisch laufen
  darf, wann Steve bestätigt und wo der Schlüssel im Benutzerkonto liegt.
  ISO, Nix-Store und Protokolle sollen keine persönlichen Schlüssel enthalten.

## Größenabschätzung

Das vorhandene ISO misst 5.072.191.488 Byte (4,72 GiB). Für NVIDIA und CUDA
ist der Zuwachs offen. Der volle Grafiktreiber ist erst für die Installation
vorgesehen. Bei CUDA hängt die ISO-Größe auch davon ab, ob lokales Diktat
bereits live nutzbar sein soll.
Zum Vergleich belegen die mehrsprachigen Whisper-Modelle `base` 142 MiB,
`small` 466 MiB und `large-v3` 2,9 GiB als Modelldateien. Bei einem späteren
Download fällt dieser Platzbedarf auf dem Zielrechner an. Die Änderung der
komprimierten ISO-Größe lässt sich mit einem Vergleichsbuild messen.
Für LUKS-Vorauswahl und Hotkeys ist nur ein kleiner Konfigurationszuwachs
zu erwarten. [Whisper-Modellgrößen](https://github.com/ggml-org/whisper.cpp/blob/master/models/README.md)
