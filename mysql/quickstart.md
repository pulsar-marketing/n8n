# MySQL Docker - Schnellstart mit lokaler Speicherung

## 📁 Ordnerstruktur

Nach dem Setup sieht dein Ordner so aus:

```
mysql-docker/
├── docker-compose.yml
├── .env
├── manage.sh
├── mysql-config/
│   └── my.cnf
└── mysql-data/           # <- Hier werden deine Datenbanken gespeichert
    ├── mysql/
    ├── performance_schema/
    ├── sys/
    └── [deine_datenbanken]/
```

## 🚀 Installation (3 Schritte)

### 1. Ordner erstellen und Dateien kopieren

```bash
mkdir ~/mysql-docker
cd ~/mysql-docker
# Kopiere alle Dateien hierher
```

### 2. Passwörter anpassen

```bash
nano .env
# oder
open -e .env
```

Ändere die Passwörter:
- `MYSQL_ROOT_PASSWORD` (wichtig!)
- `MYSQL_PASSWORD`

### 3. Starten

```bash
# Mit dem Script:
chmod +x manage.sh
./manage.sh

# Oder direkt:
docker-compose up -d
```

Fertig! 🎉

## 💾 Lokale Speicherung

**Die Datenbank wird direkt auf deiner Festplatte gespeichert:**

- **Ordner:** `./mysql-data/` (direkt neben docker-compose.yml)
- **Zugriff:** Im Finder sichtbar und zugänglich
- **Backup:** Einfach den Ordner kopieren oder mit Time Machine sichern

### Speicherort ändern

Du kannst den Speicherort anpassen in `docker-compose.yml`:

```yaml
volumes:
  # Standard: Unterordner im aktuellen Verzeichnis
  - ./mysql-data:/var/lib/mysql
  
  # Auf externe Festplatte (Beispiel):
  - /Volumes/MeineExterneFestplatte/mysql-data:/var/lib/mysql
  
  # Absoluter Pfad:
  - /Users/deinname/Documents/mysql-data:/var/lib/mysql
```

**Nach Änderung:** Container neu starten!

## 📊 Ordner-Backup

### Schnelles Backup
```bash
# Kopiere den gesamten Ordner
cp -r mysql-data mysql-data-backup

# Mit Zeitstempel
cp -r mysql-data mysql-data-backup-$(date +%Y%m%d_%H%M%S)
```

### Komprimiertes Backup
```bash
tar czf mysql-data-backup-$(date +%Y%m%d).tar.gz mysql-data
```

### Backup wiederherstellen
```bash
# 1. Container stoppen
docker-compose down

# 2. Alten Ordner entfernen/umbenennen
mv mysql-data mysql-data-old

# 3. Backup entpacken
tar xzf mysql-data-backup-20240101.tar.gz

# 4. Container neu starten
docker-compose up -d
```

## 🔄 Daten migrieren

### Auf externe Festplatte verschieben

```bash
# 1. Container stoppen
docker-compose down

# 2. Daten verschieben
mv mysql-data /Volumes/ExterneFestplatte/mysql-data

# 3. docker-compose.yml anpassen
nano docker-compose.yml
# Ändere: - /Volumes/ExterneFestplatte/mysql-data:/var/lib/mysql

# 4. Container neu starten
docker-compose up -d
```

## ⚠️ Wichtige Hinweise

1. **Nicht löschen:** Lösche den `mysql-data` Ordner nicht, wenn du deine Daten behalten möchtest
2. **Berechtigungen:** Docker erstellt die Dateien als Root - das ist normal
3. **Zugriff:** Auch wenn die Dateien sichtbar sind, öffne sie nicht direkt (nutze MySQL Tools)
4. **Backup:** Mache regelmäßig Backups (siehe oben)

## 🛠️ Verbindung

**Lokal:**
```bash
mysql -h 127.0.0.1 -P 4006 -u root -p
```

**Von PHP:**
```php
$mysqli = new mysqli("127.0.0.1", "root", "dein_passwort", "meine_datenbank", 4006);
```

**Mit Tools:** (z.B. TablePlus, MySQL Workbench)
- Host: 127.0.0.1
- Port: 4006
- User: root
- Password: (aus .env)

## 📝 Häufige Fragen

### Wie groß wird der Ordner?
- Leer: ~200 MB
- Pro Datenbank: unterschiedlich (je nach Daten)
- Wächst automatisch mit deinen Daten

### Kann ich den Ordner einfach kopieren?
- Ja! Aber nur wenn der Container gestoppt ist
- `docker-compose down` → Kopieren → `docker-compose up -d`

### Kann ich die Daten ansehen?
- Die Dateien sind binär (nicht lesbar im Editor)
- Nutze MySQL Tools zum Ansehen der Daten
- Oder: `docker exec -it mysql-server mysql -uroot -p`

### Was passiert bei `docker-compose down`?
- Container wird gestoppt und entfernt
- **Daten bleiben im mysql-data Ordner erhalten!**
- Bei erneutem Start sind alle Daten wieder da

## 🆘 Probleme?

### "Permission denied" Fehler
```bash
# Auf macOS normalerweise kein Problem
# Falls doch: Docker Desktop → Settings → Resources → File Sharing
# Füge deinen Ordner hinzu
```

### Container startet nicht
```bash
# Logs prüfen
docker-compose logs

# Häufige Ursache: mysql-data Ordner hat falsche Berechtigungen
# Lösung: Ordner löschen und neu starten
rm -rf mysql-data
docker-compose up -d
```

### Zu wenig Speicherplatz
- Prüfe: `du -sh mysql-data`
- Alte Daten löschen oder auf externe Festplatte verschieben

## 🎯 Nächste Schritte

1. ✅ Container gestartet
2. ✅ Datenbank läuft auf Port 4006
3. ➡️ Verbinde dich mit einem MySQL Client
4. ➡️ Erstelle deine ersten Tabellen
5. ➡️ Richte regelmäßige Backups ein

Viel Erfolg! 🚀