# MySQL Docker Container Setup

## Voraussetzungen

1. **Docker Desktop für macOS** installieren:
   - Download von: https://www.docker.com/products/docker-desktop
   - Nach Installation Docker Desktop starten

## Installation und Start

### 1. Dateien vorbereiten

Erstelle einen Ordner und kopiere alle Dateien hinein:
```bash
mkdir mysql-docker
cd mysql-docker
```

Kopiere folgende Dateien in diesen Ordner:
- docker-compose.yml
- .env
- mysql-config/my.cnf

### 2. Passwörter anpassen

**WICHTIG:** Öffne die `.env` Datei und ändere die Passwörter:
```bash
nano .env
# oder
open -e .env
```

### 3. Container starten

```bash
# Container im Hintergrund starten
docker-compose up -d

# Logs anzeigen (optional)
docker-compose logs -f
```

### 4. Verbindung testen

Nach ca. 30 Sekunden sollte MySQL bereit sein:

```bash
# Verbindung testen
docker exec -it mysql-server mysql -uroot -p
# Dann dein MYSQL_ROOT_PASSWORD eingeben
```

## Verbindungsdetails

- **Host:** localhost (oder 127.0.0.1)
- **Port:** 4006
- **Benutzer:** root (oder der in .env definierte MYSQL_USER)
- **Passwort:** siehe .env Datei
- **Datenbank:** siehe MYSQL_DATABASE in .env

### Beispiel-Verbindung (CLI):
```bash
mysql -h 127.0.0.1 -P 4006 -u root -p
```

### Beispiel-Verbindung (PHP):
```php
$mysqli = new mysqli("127.0.0.1", "root", "dein_passwort", "meine_datenbank", 4006);
```

### Beispiel-Verbindung (Python):
```python
import mysql.connector
conn = mysql.connector.connect(
    host="127.0.0.1",
    port=4006,
    user="root",
    password="dein_passwort",
    database="meine_datenbank"
)
```

## Nützliche Befehle

### Container verwalten
```bash
# Container stoppen
docker-compose stop

# Container starten
docker-compose start

# Container neu starten
docker-compose restart

# Container stoppen und entfernen
docker-compose down

# Container UND Daten löschen (ACHTUNG: Datenverlust!)
docker-compose down -v
```

### Logs anzeigen
```bash
# Alle Logs
docker-compose logs

# Logs live verfolgen
docker-compose logs -f

# Letzte 100 Zeilen
docker-compose logs --tail=100
```

### MySQL Shell öffnen
```bash
# Als root
docker exec -it mysql-server mysql -uroot -p

# Als definierter User
docker exec -it mysql-server mysql -u${MYSQL_USER} -p
```

### Backup erstellen
```bash
# Alle Datenbanken
docker exec mysql-server mysqldump -uroot -p --all-databases > backup_$(date +%Y%m%d).sql

# Einzelne Datenbank
docker exec mysql-server mysqldump -uroot -p meine_datenbank > backup_db_$(date +%Y%m%d).sql
```

### Backup wiederherstellen
```bash
docker exec -i mysql-server mysql -uroot -p < backup_20240101.sql
```

## Persistente Daten

Die Datenbank wird **direkt auf deiner lokalen Festplatte** gespeichert:
- **Speicherort:** `./mysql-data/` (im selben Ordner wie docker-compose.yml)
- Du kannst den Ordner direkt im Finder sehen und darauf zugreifen
- Der Ordner wird automatisch beim ersten Start erstellt

**Vorteile:**
- ✓ Daten sind direkt sichtbar und zugänglich
- ✓ Einfache Backups mit Time Machine oder anderen Tools
- ✓ Keine versteckten Docker Volumes
- ✓ Einfach auf externe Festplatte verschieben

**Wichtig:** Lösche den `mysql-data` Ordner nicht, wenn du deine Daten behalten möchtest!

Um die Daten zu sichern:
```bash
# Einfach den Ordner kopieren
cp -r mysql-data mysql-data-backup-$(date +%Y%m%d)

# Oder als Archiv
tar czf mysql-data-backup-$(date +%Y%m%d).tar.gz mysql-data
```

## Troubleshooting

### Port bereits belegt
Wenn Port 4006 bereits verwendet wird, ändere in docker-compose.yml:
```yaml
ports:
  - "4007:3306"  # Anderen Port verwenden
```

### Container startet nicht
```bash
# Status prüfen
docker-compose ps

# Detaillierte Logs
docker-compose logs mysql

# Container neu erstellen
docker-compose down
docker-compose up -d
```

### Verbindung schlägt fehl
1. Warte 30-60 Sekunden nach dem Start
2. Prüfe ob Container läuft: `docker-compose ps`
3. Prüfe Logs: `docker-compose logs mysql`
4. Teste Healthcheck: `docker inspect mysql-server | grep -A 10 Health`

### Performance-Probleme auf macOS
Wenn die Performance schlecht ist, erhöhe in Docker Desktop die Ressourcen:
- Docker Desktop → Preferences → Resources
- Mindestens 4 GB RAM zuweisen
- 2+ CPU Cores zuweisen

## Sicherheitshinweise

1. **Passwörter ändern:** Ändere unbedingt die Standard-Passwörter in der .env Datei!
2. **Nicht im Internet exponieren:** Port 4006 sollte nur lokal erreichbar sein
3. **.env Datei schützen:** Füge .env zur .gitignore hinzu, falls du Git verwendest
4. **Regelmäßige Backups:** Erstelle regelmäßig Backups deiner Datenbank

## MySQL Workbench oder andere Tools

Du kannst auch grafische Tools verwenden:
- **MySQL Workbench:** https://dev.mysql.com/downloads/workbench/
- **DBeaver:** https://dbeaver.io/
- **TablePlus:** https://tableplus.com/ (empfohlen für macOS)

Verbindungseinstellungen:
- Host: 127.0.0.1
- Port: 4006
- User: root
- Password: (dein MYSQL_ROOT_PASSWORD)

## Support

Bei Problemen:
1. Prüfe die Logs: `docker-compose logs -f`
2. Prüfe Docker Desktop ob es läuft
3. Stelle sicher dass kein anderer Service Port 4006 verwendet: `lsof -i :4006`