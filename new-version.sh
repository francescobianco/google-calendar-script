#!/bin/bash
set -e

# Impostazioni dell'API
SCOPES="https://www.googleapis.com/auth/calendar.readonly"
SERVICE_ACCOUNT_FILE="${HOME}/.google/service_account.json"
CALENDAR_ID="your_calendar_id@group.calendar.google.com"

# Imposta il contenuto del file di credenziali come variabile d'ambiente
export GOOGLE_APPLICATION_CREDENTIALS="$SERVICE_ACCOUNT_FILE"



# Leggi il contenuto del file di chiave JSON in una variabile
credentials=$(cat ${HOME}/.google/service_account.json)

# Estrai i campi necessari dal file di chiave JSON
client_email=$(echo "$credentials" | jq -r .client_email)
private_key=$(echo "$credentials" | jq -r .private_key)

echo "$private_key"

# Codifica URL-safe della chiave privata
encoded_private_key=$(echo -n "$private_key" | openssl enc -base64 -A | tr '+/' '-_' | tr -d '=')

# Effettua una richiesta HTTP per ottenere il token di accesso
curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" \
-d "grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=$(
  echo -n '{"iss":"'"$client_email"'","scope":"https://www.googleapis.com/auth/cloud-platform","aud":"https://oauth2.googleapis.com/token","exp":'$(($(date +%s)+3600))',"iat":'$(date +%s)'}' | openssl dgst -sha256 -sign <(echo "$private_key") -binary | openssl enc -base64 -A | tr '+/' '-_' | tr -d '='
)" "https://oauth2.googleapis.com/token"

echo "Token di accesso: $token"

exit


credentials=$(cat "$GOOGLE_APPLICATION_CREDENTIALS")

# Effettua una richiesta HTTP per ottenere il token di accesso
token=$(curl -X POST \
  -H "Content-Type: application/json" \
  -d "$credentials" \
  "https://oauth2.googleapis.com/token")

echo "Token di accesso: $token"

exit
curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google"
exit
# Ottieni il token di accesso
access_token=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google" | jq -r '.access_token')

echo "Access Token: $access_token"

# Data di interesse (oggi)
today=$(date -u +"%Y-%m-%dT00:00:00Z")
tomorrow=$(date -u -v+1d +"%Y-%m-%dT00:00:00Z")

# Ottieni gli eventi del calendario per la giornata di oggi
events=$(curl -s -X GET \
    -H "Authorization: Bearer $access_token" \
    "https://www.googleapis.com/calendar/v3/calendars/$CALENDAR_ID/events?timeMin=$today&timeMax=$tomorrow&singleEvents=true&orderBy=startTime")

# Salvare gli eventi in un file di testo
echo "$events" | jq -r '.items[] | "\(.start.dateTime) - \(.end.dateTime): \(.summary)"' > events.txt

echo "---"
cat events.txt