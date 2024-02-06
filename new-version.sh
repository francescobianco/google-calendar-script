#!/bin/bash

# Impostazioni dell'API
SCOPES="https://www.googleapis.com/auth/calendar.readonly"
SERVICE_ACCOUNT_FILE="service_account.json"
CALENDAR_ID="your_calendar_id@group.calendar.google.com"

# Imposta il contenuto del file di credenziali come variabile d'ambiente
export GOOGLE_APPLICATION_CREDENTIALS="$SERVICE_ACCOUNT_FILE"

# Ottieni il token di accesso
access_token=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google" | jq -r '.access_token')

# Data di interesse (oggi)
today=$(date -u +"%Y-%m-%dT00:00:00Z")
tomorrow=$(date -u -d "+1 day" +"%Y-%m-%dT00:00:00Z")

# Ottieni gli eventi del calendario per la giornata di oggi
events=$(curl -s -X GET \
    -H "Authorization: Bearer $access_token" \
    "https://www.googleapis.com/calendar/v3/calendars/$CALENDAR_ID/events?timeMin=$today&timeMax=$tomorrow&singleEvents=true&orderBy=startTime")

# Salvare gli eventi in un file di testo
echo "$events" | jq -r '.items[] | "\(.start.dateTime) - \(.end.dateTime): \(.summary)"' > events.txt
