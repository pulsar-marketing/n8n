#!/bin/bash

# MySQL Docker Container Management Script

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}MySQL Docker Container Manager${NC}"
echo "================================"
echo ""

# Funktion: Container Status prüfen
check_status() {
    if [ "$(docker-compose ps -q mysql)" ]; then
        if [ "$(docker-compose ps -q mysql --filter status=running)" ]; then
            echo -e "${GREEN}✓ Container läuft${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠ Container existiert, läuft aber nicht${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Container existiert nicht${NC}"
        return 2
    fi
}

# Hauptmenü
echo "Was möchtest du tun?"
echo ""
echo "1) Container starten"
echo "2) Container stoppen"
echo "3) Container neu starten"
echo "4) Status anzeigen"
echo "5) Logs anzeigen"
echo "6) MySQL Shell öffnen"
echo "7) Backup erstellen"
echo "8) Container entfernen (Daten bleiben erhalten)"
echo "9) Alles entfernen (inkl. Daten - ACHTUNG!)"
echo "0) Beenden"
echo ""
read -p "Wähle eine Option (0-9): " choice

case $choice in
    1)
        echo -e "\n${YELLOW}Starte Container...${NC}"
        docker-compose up -d
        echo -e "${GREEN}Container gestartet!${NC}"
        echo "Warte 10 Sekunden bis MySQL bereit ist..."
        sleep 10
        check_status
        ;;
    2)
        echo -e "\n${YELLOW}Stoppe Container...${NC}"
        docker-compose stop
        echo -e "${GREEN}Container gestoppt!${NC}"
        ;;
    3)
        echo -e "\n${YELLOW}Starte Container neu...${NC}"
        docker-compose restart
        echo -e "${GREEN}Container neu gestartet!${NC}"
        ;;
    4)
        echo -e "\n${YELLOW}Status:${NC}"
        check_status
        echo ""
        docker-compose ps
        ;;
    5)
        echo -e "\n${YELLOW}Zeige Logs (Strg+C zum Beenden):${NC}\n"
        docker-compose logs -f
        ;;
    6)
        echo -e "\n${YELLOW}Öffne MySQL Shell...${NC}"
        echo "Gib dein Root-Passwort ein:"
        docker exec -it mysql-server mysql -uroot -p
        ;;
    7)
        BACKUP_FILE="mysql_backup_$(date +%Y%m%d_%H%M%S).sql"
        echo -e "\n${YELLOW}Erstelle Backup: $BACKUP_FILE${NC}"
        echo "Gib dein Root-Passwort ein:"
        docker exec mysql-server mysqldump -uroot -p --all-databases > "$BACKUP_FILE"
        echo -e "${GREEN}Backup erstellt: $BACKUP_FILE${NC}"
        ;;
    8)
        echo -e "\n${RED}WARNUNG: Container wird entfernt (Daten im mysql-data/ Ordner bleiben erhalten)${NC}"
        read -p "Fortfahren? (ja/nein): " confirm
        if [ "$confirm" = "ja" ]; then
            docker-compose down
            echo -e "${GREEN}Container entfernt!${NC}"
            echo -e "${YELLOW}Daten sind weiterhin im mysql-data/ Ordner gespeichert${NC}"
        else
            echo "Abgebrochen."
        fi
        ;;
    9)
        echo -e "\n${RED}ACHTUNG: Dies löscht Container UND den mysql-data/ Ordner unwiderruflich!${NC}"
        read -p "Bist du sicher? Tippe 'LÖSCHEN' um fortzufahren: " confirm
        if [ "$confirm" = "LÖSCHEN" ]; then
            docker-compose down
            rm -rf mysql-data
            echo -e "${GREEN}Container und Daten gelöscht!${NC}"
        else
            echo "Abgebrochen."
        fi
        ;;
    0)
        echo "Auf Wiedersehen!"
        exit 0
        ;;
    *)
        echo -e "${RED}Ungültige Auswahl!${NC}"
        exit 1
        ;;
esac