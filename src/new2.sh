#!/bin/bash

# Impostazioni
CLIENT_SECRET_FILE="${HOME}/.google/client_secret.json"
CALENDAR_ID="info.francescobianco@gmail.com"

# Estrai i valori necessari dal file client_secret.json
client_id=$(sed -n 's/.*"client_id":"\(.*\)".*/\1/p' $CLIENT_SECRET_FILE | cut -d '"' -f 1)
client_secret=$(sed -n 's/.*"client_secret":"\(.*\)".*/\1/p' $CLIENT_SECRET_FILE | cut -d '"' -f 1)
refresh_token=$(sed -n 's/.*"refresh_token":"\(.*\)".*/\1/p' $CLIENT_SECRET_FILE | cut -d '"' -f 1)

redirect_uri="http://localhost:9000"

echo "Client ID: $client_id"
echo "Client Secret: $client_secret"
echo "Refresh Token: $refresh_token"

SCOPE="https://www.googleapis.com/auth/calendar.readonly"

# Costruisci l'URL di autorizzazione
oauth_url="https://accounts.google.com/o/oauth2/auth"
oauth_url+="?client_id=$client_id"
oauth_url+="&redirect_uri=$redirect_uri"
oauth_url+="&scope=$SCOPE"
oauth_url+="&response_type=code"
oauth_url+="&access_type=offline"

echo "URL di autorizzazione: $oauth_url"
porta=9000
# Accetta la connessione e legge la richiesta HTTP

response="HTTP/1.1 200 OK\r\nContent-Length: 12\r\n\r\nHello, World!"
request=$(echo -ne "${response}" | nc -l -p "$porta" | sed -n 's/GET \([^ ]*\).*/\1/p')


echo "Richiesta HTTP: $request"

code=$(echo "$request" | sed -n 's/.*\?code=\([^&]*\).*/\1/p')

echo "Code: $code"

# Esegui la chiamata curl
#curl -X GET "$oauth_url" | sed -n 's/.*HREF="\(.*\)".*/\1/p' | sed 's/&amp;/\&/g'

# Effettua la richiesta per ottenere il token di accesso
response=$(curl -s -d "client_id=$client_id&client_secret=$client_secret&code=$code&redirect_uri=$redirect_uri&grant_type=authorization_code" https://oauth2.googleapis.com/token)

echo "Response: $response"

# Estrai il token di accesso dall'output della richiesta
access_token=$(echo "$response" | jq -r '.access_token')

# Utilizza il token di accesso nelle tue chiamate API aggiungendo l'header Authorization
echo "Bearer $access_token"



events=$(curl -s -X GET \
    -H "Authorization: Bearer $access_token" \
  "https://www.googleapis.com/calendar/v3/users/me/calendarList")




echo "Events: $events"

