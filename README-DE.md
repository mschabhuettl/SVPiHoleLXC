<div align="center">
  <a href="#">
    <img src="https://raw.githubusercontent.com/mschabhuettl/PiBlockLXC/main/misc/images/logo.png" height="150px" />
  </a>
</div>
<h1 align="center">PiBlockLXC - Fortgeschrittenes Pi-hole LXC mit RPiList und umfassenden Erweiterungen</h1>

<div align="center">
  <img src="https://avatars.githubusercontent.com/u/56664851" alt="RPiList" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handschlag" height="50" />
  <img src="https://github.com/home-assistant/brands/blob/master/core_integrations/pi_hole/icon.png?raw=true" alt="Pi-hole" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handschlag" height="50" />
  <img src="https://avatars.githubusercontent.com/u/8418678" alt="pihole-updatelists" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handschlag" height="50" />
  <img src="https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/logo-81x112.png" alt="Proxmox VE Helper-Scripts" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handschlag" height="50" />
  <img src="https://avatars.githubusercontent.com/u/2678585" alt="Proxmox" height="100" />
</div>

Ein Projekt zur Vereinfachung der Installation von [Pi-hole](https://pi-hole.net/) in einem LXC-Container auf Proxmox, automatisch erweitert mit Listen von [RPiList/specials](https://github.com/RPiList/specials) und [Firebog](https://v.firebog.net/hosts/lists.php).

## Über das Projekt

Dieses Projekt baut auf den Hilfsskripten von [tteck/Proxmox](https://github.com/tteck/Proxmox) auf und erweitert sie automatisch um Listen von [RPiList/specials](https://github.com/RPiList/specials) und [Firebog](https://v.firebog.net/hosts/lists.php). Ziel ist es, die Einrichtung eines Pi-hole LXC-Containers auf einem Proxmox-Server zu vereinfachen, indem eine Auswahl an Blocklisten für Werbung, Tracking und potenziell schädliche Websites zur Pi-hole-Basisinstallation hinzugefügt wird.

## Funktionen

- Verwendet das Grundskript von [tteck](https://github.com/tteck/Proxmox) zur Erstellung von LXC.
- Integriert automatisch Blocklisten von [RPiList/specials](https://github.com/RPiList/specials) und [Firebog](https://v.firebog.net/hosts/lists.php) durch [jacklul/pihole-updatelists](https://github.com/jacklul/pihole-updatelists).
- Vereinfacht die Bereitstellung eines Pi-hole LXC-Containers mit vorkonfigurierten Blocklisten für verbesserten Netzwerkschutz.

## Pi-hole Übersicht

<p align="center">
  <img src="https://github.com/home-assistant/brands/blob/master/core_integrations/pi_hole/icon.png?raw=true" height="100">
</p>

[Pi-hole](https://pi-hole.net/) ist eine kostenlose, Open-Source-Anwendung zur Blockierung unerwünschter Internetinhalte auf Netzwerkebene. Es dient als DNS-Sinkhole, um Werbung, Tracker und anderen unerwünschten Verkehr zu blockieren, bevor er die Geräte der Benutzer erreicht. Pi-hole kann auch als DHCP-Server fungieren und bietet weitere Netzwerkmanagementfunktionen. Es ist hochgradig anpassbar und ermöglicht eine detaillierte Konfiguration, um den Datenschutz- und Sicherheitsanforderungen der Benutzer gerecht zu werden.

## Schnellstart

Um einen neuen Proxmox VE Pi-hole LXC zu erstellen, führen Sie den folgenden Befehl in der Proxmox VE Shell aus:

```bash
bash -c "$(wget -qLO - https://github.com/mschabhuettl/PiBlockLXC/raw/main/ct/piblocklxc.sh)"
```

### ⚡ Standard-Einstellungen

- **RAM:** 1024MiB
- **Speicher:** 16GB
- **CPU:** 2vCPU

### Pi-hole updatelists Integration

Das Skript enthält eine Option zur Integration von `pihole-updatelists`, einem leistungsfähigen Werkzeug zur automatischen Verwaltung von Pi-hole's Block-, White- und Blacklists durch Abrufen von Updates von festgelegten Remote-Quellen.

#### Installationsaufforderung für pihole-updatelists

Während der Einrichtung werden Sie gefragt, ob Sie `pihole-updatelists` hinzufügen möchten:

```bash
Would you like to add pihole-updatelists? <Y/n>
```

Die Auswahl von Yes (Standardeinstellung und **empfohlen**) initiiert die Konfiguration von `pihole-updatelists`.

Dieser Schritt ist entscheidend für die Automatisierung der Aktualisierung Ihrer Listen direkt von Remote-Quellen, um sicherzustellen, dass Ihre Pi-hole-Konfiguration weiterhin effektiv gegen Werbung, Tracker und bösartige Sites wirkt, ohne manuelle Eingriffe.

#### Zeitplan-Konfiguration und Systemüberschreibungen

Um Konflikte mit den Standard-Pi-hole-Updateaufgaben zu vermeiden und die Updatefrequenz für Ihre Umgebung anzupassen, richtet das Skript einen benutzerdefinierten Zeitplan für `pihole-updatelists` ein. Speziell wird Pi-hole's eingebautes UpdateGravity-Job im Crontab deaktiviert, um Überschneidungen zu vermeiden. Dann wird ein täglicher Trigger für `pihole-updatelists` um 03:00 Uhr morgens eingerichtet, um sicherzustellen, dass Listenaktualisierungen während der Nebenzeiten verarbeitet werden, um mögliche Auswirkungen auf die Leistung Ihres Netzwerks zu minimieren.

#### Einrichtung der pihole-updatelists Konfiguration

Damit pihole-updatelists korrekt funktioniert, ist eine spezifische Konfigurationsdatei erforderlich. Das Skript erleichtert dies durch das Herunterladen einer [vorkonfigurierten Konfigurationsdatei](https://raw.githubusercontent.com/mschabhuettl/PiBlockLXC/main/config/pihole-updatelists.conf) aus diesem Repository. Diese Datei enthält Einstellungen, die festlegen, welche Remote-Quellen für die Aktualisierung der Pi-hole-Listen verwendet werden sollen, wodurch der Einrichtungsprozess vereinfacht wird und sichergestellt ist, dass pihole-updatelists mit minimalem Benutzereingriff betriebsbereit ist.

#### Ausführen des ersten Listen-Updates

Mit `pihole-updatelists` installiert und konfiguriert, führt das Skript ein erstes Update durch, um die neu festgelegten Einstellungen sofort anzuwenden. Dieser anfängliche Durchlauf holt die neuesten Versionen Ihrer festgelegten Block-, White- und Blacklists von ihren Remote-Quellen ab und integriert sie in Ihre Pi-hole-Konfiguration. Dadurch werden die Filterfähigkeiten von Pi-hole von Anfang an verbessert und bieten einen verbesserten Schutz gegen unerwünschte Internetinhalte.

Zusammenfassend führt die Einbeziehung von `pihole-updatelists` in den Einrichtungsprozess eine Automatisierungsebene in die Listenverwaltung von Pi-hole ein, wodurch der Bedarf an manuellen Updates erheblich reduziert wird und Ihr Netzwerk von den neuesten Listenaktualisierungen profitiert, ohne zusätzlichen Aufwand für den Benutzer.

# Nach der Installation

## Festlegen Ihres Passworts

Um Ihr Pi-hole-Admin-Passwort festzulegen oder zu aktualisieren, verwenden Sie den folgenden Befehl:

```bash
pihole -a -p
```

**Hinweis:** Bitte starten Sie den Pi-hole LXC nach der Installation neu.

**Zugriff auf die Pi-hole-Schnittstelle:** `IP_OF_YOUR_PIHOLE/admin`

## Konfiguration

Nach der Installation können Sie die Konfiguration von Pi-hole über dessen Weboberfläche oder durch Bearbeiten der Konfigurationsdateien im Verzeichnis `/etc/pihole/` anpassen.

Für automatische Listenaktualisierungen über `pihole-updatelists` finden Sie die Konfigurationsdatei unter `/etc/pihole-updatelists.conf`.

## Anpassen Ihrer Whitelist und Blacklist

Die Ausgewogenheit zwischen Sicherheit und Zugänglichkeit in Ihrem Netzwerk zu verbessern, erfordert eine sorgfältige Kuratierung von Blacklists und Whitelists. Dieses Projekt integriert diese Listen, um unerwünschte Inhalte zu filtern und gleichzeitig den Zugang zu notwendigen Ressourcen sicherzustellen. Hier erfahren Sie, wie Sie diese Listen an Ihre spezifischen Bedürfnisse anpassen können:

### Integrierte Listen

- **Blacklists**: Wir integrieren umfassende Blacklists von Quellen wie [RPiList/specials](https://github.com/RPiList/specials), [Firebog](https://v.firebog.net/hosts/lists.php?type=all) und [StevenBlack](https://github.com/StevenBlack/hosts), um robusten Schutz gegen aufdringliche Werbung, Tracker und bösartige Websites zu gewährleisten.

- **Whitelists**: Um den Zugang zu wesentlichen und häufig genutzten Domains zu erhalten, werden Whitelists von [anudeepND/whitelist](https://github.com/anudeepND/whitelist) und [RPiList/specials](https://github.com/RPiList/specials) verwendet. Diese Listen sind so kuratiert, dass sie die Wahrscheinlichkeit, legitime Websites zu blockieren, minimieren und so ein nahtloses Surferlebnis gewährleisten.

<details>
<summary><b>Optionale Whitelist-URLs</b></summary>

Für Benutzer, die spezifische Funktionen von Diensten wie Slickdeals, Fatwallet oder ähnlichen Plattformen benötigen, kann es notwendig sein, bestimmte Domains, die generell als Tracker oder Werbung eingestuft werden, auf die Whitelist zu setzen. Hier sind zusätzliche Listen von anudeepND, die in Ihren `WHITELIST_URL`-Abschnitt aufgenommen werden können, wenn nötig:

- **Referral Sites**: Personen, die Dienste wie Slickdeals und Fatwallet nutzen, benötigen einige Sites (die meisten davon sind entweder Tracker oder Werbung), die auf die Whitelist gesetzt werden müssen, um ordnungsgemäß zu funktionieren. Diese Datei enthält einige Analyse- und Werbeserver-Sites wie doubleclick.net und andere. Wenn Sie nicht wissen, was diese Dienste sind, meiden Sie diese Liste.
  - URL: `https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/referral-sites.txt`

- **Optionale Liste**: Diese Datei enthält Domains, die je nach genutztem Dienst auf die Whitelist gesetzt werden müssen. Sie kann einige Tracking-Sites enthalten, aber manchmal ist es notwendig, schlechte Domains hinzuzufügen, um einige Dienste funktionieren zu lassen. Derzeit gibt es kein Skript für diese Liste, Sie müssen Domains manuell zu Ihrem Pi-Hole hinzufügen.
  - URL: `https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt`

Um diese Listen einzuschließen, fügen Sie deren URLs in den `WHITELIST_URL`-Abschnitt Ihrer `pihole-updatelists.conf`-Datei hinzu. Denken Sie daran, dass Sie diese Einträge jederzeit entfernen können, wenn Sie sie für Ihren Gebrauch nicht notwendig finden oder wenn Sie die Exposition gegenüber Tracking und Werbung minimieren möchten.

</details>

### Konfigurieren von `pihole-updatelists.conf`

Für eine detaillierte Anpassung Ihrer Filterlisten empfehlen wir, die `pihole-updatelists.conf`-Konfigurationsdatei zu überprüfen. In dieser Datei finden Sie die URLs für die Blacklists und Whitelists, die Sie nach Bedarf anpassen können. Sie können Listen hinzufügen, die für Ihre spezifischen Anforderungen relevant sind, oder solche entfernen, die Sie nicht benötigen.

- **Listen hinzufügen/entfernen**: Fügen Sie direkt URLs für zusätzliche Listen in die `pihole-updatelists.conf` ein oder entfernen Sie Einträge, die nicht benötigt werden. Dies gibt Ihnen die volle Kontrolle über die Inhalte, die gefiltert oder zugelassen werden.

- **Listen aktualisieren**: Nachdem Sie Änderungen an der `pihole-updatelists.conf` vorgenommen haben, führen Sie bitte `pihole-updatelists` aus, um Ihre Anpassungen anzuwenden und die Listen entsprechend zu aktualisieren.

Diese Flexibilität ermöglicht es Ihnen, ein Pi-hole-Erlebnis zu schaffen, das auf Ihre Bedürfnisse zugeschnitten ist, indem sichergestellt wird, dass nur die Inhalte gefiltert werden, die Sie wünschen.

### Fazit

Das Anpassen Ihrer Whitelist und Blacklist bietet einen proaktiven Ansatz zur Verwaltung von Internetinhalten und schafft ein optimales Gleichgewicht zwischen dem Schutz Ihres Netzwerks und der Gewährleistung eines nahtlosen Zugangs zu legitimen Websites. Durch die Feinabstimmung dieser Listen können Sie Ihr Online-Erlebnis verbessern und sowohl Sicherheit als auch Funktionalität priorisieren, um Ihren einzigartigen Bedürfnissen gerecht zu werden.

## Unterstützung und Beiträge

Feedback, Vorschläge und Beiträge sind willkommen! Wenn Sie dazu beitragen möchten, dieses Projekt zu verbessern, zögern Sie nicht, Issues oder Pull Requests zu erstellen. Ihr Input ist wertvoll, und ich schätze jeden Beitrag, den Sie leisten können. Vielen Dank, dass Sie in Erwägung ziehen, mitzuhelfen!

## Danksagungen

- [tteck/Proxmox](https://github.com/tteck/Proxmox) für die grundlegenden Proxmox-Hilfsskripte.
- [RPiList/specials](https://github.com/RPiList/specials) für die umfassenden Listen zum Schutz gegen Fake-Shops und mehr.
- [Firebog](https://v.firebog.net/hosts/lists.php) für die kuratierten Blocklisten.
- [jacklul/pihole-updatelists](https://github.com/jacklul/pihole-updatelists) für das Skript, das automatische Listenaktualisierungen ermöglicht.
- **[anudeepND/whitelist](https://github.com/anudeepND/whitelist)** für das Angebot einer robusten Sammlung von häufig whitelisted Websites, die sicherstellen, dass wesentliche und häufig genutzte Seiten zugänglich bleiben und zu einer ausgewogenen und effizienten Werbeblockierung beitragen.

## Logo-Anerkennung

Das Logo für dieses Projekt, das eine Katze zeigt, die eine Himbeere umarmt, wurde einzigartig von OpenAI's DALL·E generiert, einem hochmodernen KI-Modell, das auf die Erstellung von Bildern aus Textbeschreibungen spezialisiert ist. Wir haben uns für ein Katzenmotiv entschieden, um die Verbindung des Projekts zum Internet zu symbolisieren, wo Katzen als Symbole für Neugier und technische Verspieltheit im Internet herrschen. Diese Wahl fängt das Wesen unserer Initiative ein – ein freundlicher und innovativer Ansatz zur Netzwerksicherheit, präsentiert in einem einzigartigen und kreativen Design.

Warum eine Katze? In der Ära des digitalen Zeitalters überschreiten Katzen ihre Rolle als bloße Haustiere und werden zu Ikonen der Internetkultur. Von viralen Videos bis hin zu Memes sind Katzen und das Internet untrennbar miteinander verbunden. Die Katze in unserem Logo repräsentiert nicht nur die spielerische und zugängliche Seite der Technologie, sondern auch die Weisheit und Agilität, mit der wir die Komplexität der Netzwerksicherheit navigieren. Dieses Logo wurde mit DALL·E erstellt und hebt den innovativen Geist unseres Projekts hervor sowie unser Engagement, Technologie mit Kreativität zu verbinden.

## Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe die [LICENSE](https://github.com/mschabhuettl/PiBlockLXC/blob/main/LICENSE)-Datei für Details.

Pi-hole® ist ein eingetragenes Warenzeichen von Pi-hole LLC.
Proxmox® ist ein eingetragenes Warenzeichen von Proxmox Server Solutions GmbH.
Dieses Projekt steht in keiner Verbindung mit Pi-hole oder Proxmox.
