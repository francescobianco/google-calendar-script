

main

[ "$1" = "--sync" ] && refresh_interval=0

if [ "$1" = "--auth" ]; then
  read -r -p "Google Client Id: " client_id
  read -r -p "Google Client Secret: " client_secret
  gcalcli --client-id "${client_id}" --client-secret "${client_secret}" list
  exit 0
fi
