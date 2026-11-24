# Testprotokoll

## 2026-11-25 – Element Desktop und Telegram Desktop

Release-ISO aus `rwjg10fhqp55xk8npd0jawmdrif9svzl` (Nix-Store-Hash),
4.635.574.272 Byte (4,32 GiB).

- **Tabelle und Programme geprüft.** Die aus `programme.xlsx` erzeugte
  `programme.json` entspricht allen elf Zeilen und allen vier Schaltern.
  Der Live-Systempfad enthält die sieben ausgewählten Tabellenprogramme.
  Aus den Installer-Dateien der ISO wurde separat der Fresh-Systempfad mit
  allen elf Tabellenprogrammen gebaut.
- **Dock-Vorgaben geprüft.** Die kompilierten GNOME-Einstellungen enthalten
  fünf Favoriten für Live und acht für Fresh, jeweils in Tabellenreihenfolge.
  In beiden Profilen folgen `element-desktop.desktop` und
  `org.telegram.desktop.desktop` auf Firefox. Die zugehörigen Starter und
  die darin aufgerufenen Programme `element-desktop` und `Telegram` sind in
  beiden gebauten Systempfaden vorhanden.
- **Live-Sitzung geprüft.** Die endgültige ISO startete ohne Fenster und ohne
  virtuelle Festplatte. In der Wayland-Sitzung des Live-Benutzers meldete
  GNOME Chromium, VS Code, Firefox, Element und Telegram als Favoriten.
  Beide Messenger waren im Systempfad verfügbar. Der Test umfasste die
  Desktop-Integration. Anmeldung und Nachrichtenaustausch wurden nicht geprüft.

## 2026-11-24/25 – Geführte Partitionierung und Ruhezustand

Test-ISO aus `54ivz82bgxzlzp1pxjnwvv86ggac2faq` (Nix-Store-Hash),
4.347.205.632 Byte. QEMU/KVM ohne Fenster, UEFI, 6 vCPUs, 6 GiB RAM.
Als Installationsziel war jeweils nur eine leere virtuelle 64-GiB-Platte
angeschlossen. Die Live-Benutzersitzung meldete über `loginctl` den Typ
`wayland`.

- **Vorauswahl geprüft.** Beim ersten Öffnen der deutschen Partitionsseite
  waren „Festplatte löschen“, „Swap (mit Ruhezustand)“ und „Verschlüssele
  System“ ausgewählt. Ohne Passphrase blieb „Weiter“ gesperrt. Nach zweimaliger
  Eingabe zeigte die Zusammenfassung EFI, System und Swap. „Jetzt installieren“
  musste separat bestätigt werden.
- **Fehler im ersten Versuch behoben.** Der Installer legte verschlüsselten
  Swap an, aktivierte ihn aber nicht. Calamares lieferte den Anzeigenamen
  `LUKS2`, während das Mount-Modul Kleinbuchstaben erwartete. Im erzeugten
  Zielsystem war `swapDevices` leer. Mount-Modul und Konfigurationsgenerator
  erkennen verschlüsselten Swap jetzt am Mapper-Namen.
- **Verschlüsseltes Layout geprüft.** 1 GiB FAT32 für EFI, rund 54,2 GiB
  LUKS2 mit ext4 für das System und 8,8 GiB LUKS2 für Swap. Im korrigierten
  Lauf zeigte `swapon` den aktiven Mapper. `swapDevices` und
  `boot.resumeDevice` bezeichneten denselben Mapper. Die Initrd-Konfiguration
  verwies auf die äußere LUKS-UUID.
- **Ruhezustand mit LUKS2 bestanden.** Das vollständige Fresh-Profil erreichte
  „Alles erledigt“. Ohne ISO von der Platte gestartet, die LUKS-Passphrase
  eingegeben und als `steve` in GNOME angemeldet. Aus der Sitzung löste
  `systemctl hibernate` das Ausschalten der VM aus. Bei einem neuen QEMU-Start
  von derselben Platte genügte wieder eine Passphrase. Das Systemjournal
  bestätigte die Rückkehr aus `hibernate`. Boot-ID, GNOME-Shell-PID und ein
  zufälliger Marker unter `/run` hatten dieselben Werte wie vor dem Ausschalten.
- **Abwahl von LUKS geprüft.** Im zweiten Lauf wurde der Verschlüsselungshaken
  entfernt. Calamares ließ „Swap (mit Ruhezustand)“ ausgewählt und legte
  ext4 sowie eine eigene unverschlüsselte Swap-Partition an. Im laufenden
  Installer war `/dev/vda3` aktiv. In der Zielkonfiguration verwiesen
  `swapDevices` und `boot.resumeDevice` auf dieselbe Swap-UUID. Für diesen
  Lauf waren in einer temporären Kopie der Programmtabelle sämtliche
  `fresh`- und `fresh dock`-Einträge deaktiviert. GNOME und GDM blieben
  Teil der Installation.
- **Ruhezustand ohne LUKS bestanden.** Nach einer Unterbrechung des ersten
  unverschlüsselten Laufs auf dem Host wurde auf einer neuen Testplatte
  installiert. Die VM startete ohne ISO. Nach Anmeldung und
  `systemctl hibernate` beendete sich QEMU. Beim erneuten Start bestätigten
  das Journal, dieselbe Boot-ID, die GNOME-Shell-PID und der RAM-Marker die
  erfolgreiche Wiederaufnahme. Die Test-VMs wurden beendet und ihre
  temporären Platten, UEFI-Daten und Zugangsdaten entfernt.

## 2026-11-24 – Programme und Dock-Favoriten aus Excel

Endgültige ISO aus `sn6sh6czbnn39nrj6sj2ps7xvblphyx0` (Nix-Store-Hash),
4.347.205.632 Byte. Zweiter Lauf mit eigener leerer 64-GiB-Platte, UEFI,
6 vCPUs und 6 GiB RAM.

- **Gebaut und geprüft.** Im Live-Systemprofil sind die fünf Programme aus
  der Spalte `live` und alle drei vorgesehenen Dock-Starter vorhanden.
  Die Befehle für OrcaSlicer, Podman, Podman Desktop, Steam und Windscribe
  fehlen wie vorgesehen im Live-Systempfad.
- **Fresh-Profil geprüft.** Das gebaute Zielprofil enthält alle neun
  Tabellenprogramme, zusätzlich die Podman-Desktop-GUI für die Podman-Zeile
  und alle sechs ausgewählten Desktop-Dateien. Die Prüfung erfasste die
  Programme im Systempfad und die Starter. Die einzelnen Anwendungen
  wurden dabei nicht ausgeführt.
- **Änderungen an Excel geprüft.** In einer separaten Tabellenkopie für
  Live Firefox abgewählt und Podman mit Dock-Symbol angewählt. Die
  Nix-Auswertung entfernte Firefox aus den Systempaketen, aktivierte Podman
  und ersetzte Firefox im Dock durch Podman Desktop.
- **Live-Sitzung bestanden.** In der gebooteten ISO waren alle fünf
  vorgesehenen Programme im Suchpfad. GNOME meldete Chromium, VS Code und
  Firefox als Favoriten in Tabellenreihenfolge. Der Schlüssel
  `org.gnome.shell favorite-apps` war für den Live-Benutzer beschreibbar.
- **Installation bestanden.** Von der schlankeren ISO mit Internetverbindung
  bis „Alles erledigt“ installiert. Calamares übernahm `programme.json`
  nach `/etc/nixos/` im Zielsystem. GNOME und GDM waren aktiviert.
- **Erster Login bestanden.** Ohne ISO von der virtuellen Platte gestartet
  und über GDM als `steve` angemeldet. Im GNOME-Terminal zeigte `lsblk`
  `/` auf `vda2`. `gsettings get org.gnome.shell favorite-apps` ergab
  Chromium, Hermes Agent Desktop, VS Code, Podman Desktop, Steam und Firefox
  in dieser Reihenfolge. `command -v` bestätigte Podman, Podman Desktop,
  Steam, OrcaSlicer und Windscribe im installierten System.
- **Erneuter Start im sichtbaren Fenster bestanden.** Nach dem Löschen der
  Vergleichsplatte startete die aufbewahrte Installation erneut von ihrer
  64-GiB-Testplatte, ohne ISO. Die Anmeldung als `steve` öffnete den
  GNOME-Desktop im QEMU-Fenster. Der Benutzer bestätigte die Sitzung.
- **Abschluss.** Der QEMU-Dienst wurde beendet. Die Hostprüfung ergab
  `ActiveState=inactive` und `MainPID=0`. Die letzte Testplatte, ihre
  UEFI-Daten und die lokale Passwortdatei wurden gelöscht. Das
  VM-Zustandsverzeichnis war danach leer. Die temporären Testverzeichnisse
  waren entfernt. Die getestete Live-ISO ist unter `result/iso/` verfügbar.

## 2026-11-24 – Geführte GNOME-Installation in der VM

Vergleichslauf mit der ISO aus `gapryx9qd43mr3gh9mkhfj1pqngfp57q`
(Nix-Store-Hash, gemeinsame Programmauswahl vor der Profiltrennung).
QEMU/KVM lief ohne Fenster mit UEFI, 6 vCPUs, 6 GiB RAM und einer
neuen virtuellen 64-GiB-Platte.

- **Seitenfolge bestanden.** Auf „Benutzer“ folgte direkt „Unfree software“.
  „Unfreie Software erlauben“ war angehakt.
- **Zielauswahl geprüft.** Auf der Zusammenfassung stand ausschließlich
  die Testplatte `/dev/vda` als Löschziel. Calamares legte GPT mit 1 GiB
  FAT für EFI und einer ext4-Systempartition an.
- **Zielkonfiguration geprüft.** Die von Calamares erzeugte
  `configuration.nix` aktiviert GNOME, GDM und `nixpkgs.config.allowUnfree`.
- **Installation und Anmeldung bestanden.** Calamares meldete „Alles erledigt“.
  Nach dem Ausschalten startete die VM ohne angeschlossene ISO über den UEFI-
  Eintrag „Linux Boot Manager“. Die Anmeldung mit dem angelegten Passwort
  öffnete GNOME. Im GNOME-Terminal bestätigten `whoami` und `loginctl` das
  Testkonto auf `seat0`. `lsblk` zeigte `/boot` auf `vda1` und `/` auf
  `vda2`.

## 2026-11-24 – Vorauswahl für unfreie Software in Calamares

**Bestanden.** Beim ersten Öffnen der Seite war „Unfreie Software erlauben“
bereits angehakt. Der deutsche Hinweis zu den Ausnahmen für Steam und
Visual Studio Code war sichtbar.

| Testumgebung | Geprüfter Stand |
| --- | --- |
| Repository | Commit `95f9149` |
| Live-ISO | `nixos-gnome-26.05.20261122.0dc498b-x86_64-linux.iso`, aus diesem Commit gebaut |
| VM | QEMU/KVM mit UEFI, 6 vCPUs, 6 GiB RAM und einer frischen virtuellen 64-GiB-Platte |

**Durchführung.** Von der ISO in die deutsche GNOME-Sitzung booten und
„System installieren“ öffnen. Mit temporären Benutzerdaten bis zur
Desktop-Auswahl gehen, GNOME ausgewählt lassen und „Weiter“ wählen.
Den Zustand der Checkbox vor der ersten Eingabe auf dieser Seite ablesen.

**Testumfang.** Dieser Lauf endete auf der Checkbox-Seite vor der
Partitionierung. Die späteren Installationsläufe oben bestätigen die
Übernahme der Vorauswahl und den ersten Start. Das Abwählen ist weiterhin
ungetestet.

**Abschluss.** Nach dem Schließen des VM-Fensters bestätigte die Hostprüfung,
dass der QEMU-Prozess beendet und der Testdienst entladen war. Die Platte
der vorherigen Installations-VM war gelöscht. Bei der abschließenden
Bereinigung wurden auch die Platte des Checkbox-Tests (196 KiB belegt),
die UEFI-Daten, Screenshots und temporären Prüfskripte entfernt.
