#!/bin/bash
set -e

# Impostazioni dell'API
SCOPES="https://www.googleapis.com/auth/calendar.readonly"
SERVICE_ACCOUNT_FILE="${HOME}/.google/service_account.json"
CALENDAR_ID="aW5mby5mcmFuY2VzY29iaWFuY29AZ21haWwuY29t@group.calendar.google.com"

# Imposta il contenuto del file di credenziali come variabile d'ambiente
export GOOGLE_APPLICATION_CREDENTIALS="$SERVICE_ACCOUNT_FILE"


# Leggi il contenuto del file di chiave JSON in una variabile
credentials=$(cat "${HOME}/.google/service_account.json")
SCOPES="https://www.googleapis.com/auth/calendar.readonly"

# Estrai i campi necessari dal file di chiave JSON
client_email=$(echo "$credentials" | jq -r .client_email)
private_key=$(echo "$credentials" | jq -r .private_key)
# Creiamo il token JWT
header='{"alg":"RS256","typ":"JWT"}'
payload='{
  "iss": "'"$client_email"'",
  "scope": "https://www.googleapis.com/auth/calendar.readonly",
  "aud": "https://oauth2.googleapis.com/token",
  "exp": '"$(($(date +%s)+3600))"',
  "iat": '"$(date +%s)"'
}'

# Codifica URL-safe dell'header e del payload in base64
encoded_header=$(echo -n "$header" | openssl enc -base64 -A | tr '+/' '-_' | tr -d '=')
encoded_payload=$(echo -n "$payload" | openssl enc -base64 -A | tr '+/' '-_' | tr -d '=')

# Concatena header e payload con un punto
jwt="$encoded_header.$encoded_payload"

# Firma il token JWT con la chiave privata e lo codifica in base64
signature=$(echo -n "$jwt" | openssl dgst -sha256 -sign <(echo "$private_key") -binary | openssl enc -base64 -A | tr '+/' '-_' | tr -d '=')

# Concatena la firma al token JWT
jwt="$jwt.$signature"

echo "$jwt" > jwt.json

# Effettua una richiesta HTTP per ottenere il token di accesso
token=$(curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" \
-d "grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=$jwt&scope=$SCOPES" \
"https://oauth2.googleapis.com/token" | jq -r .access_token)


echo "Token di accesso: $token"
# Ottieni il token di accesso
access_token=$token

echo "Access Token: $access_token"

# Data di interesse (oggi)
today=$(date -u +"%Y-%m-%dT00:00:00Z")
tomorrow=$(date -u -v+1d +"%Y-%m-%dT00:00:00Z")

# Ottieni gli eventi del calendario per la giornata di oggi
events=$(curl -s -X GET \
    -H "Authorization: Bearer $access_token" \
  "https://www.googleapis.com/calendar/v3/users/me/calendarList")
# "https://www.googleapis.com/calendar/v3/calendars/$CALENDAR_ID/events?timeMin=$today&timeMax=$tomorrow&singleEvents=true&orderBy=startTime")


# Salvare gli eventi in un file di testo
echo "$events"
#| jq -r '.items[] | "\(.start.dateTime) - \(.end.dateTime): \(.summary)"' > events.txt

echo "---"
cat events.txt