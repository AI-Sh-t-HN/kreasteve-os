# Testprotokoll

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

**Testumfang.** Der Lauf endete auf der Checkbox-Seite vor der Partitionierung.
Das Abwählen, die Übernahme ins installierte System und dessen erster Start
bleiben ungetestet.

**Abschluss.** Nach dem Schließen des VM-Fensters bestätigte die Hostprüfung,
dass der QEMU-Prozess beendet und der Testdienst entladen war. Die Platte
der vorherigen Installations-VM war gelöscht. Vom Checkbox-Test lagen bei
der Prüfung noch die neue virtuelle Platte (196 KiB belegt), UEFI-Daten,
zwei Screenshots und das Testskript außerhalb des Repositorys.
