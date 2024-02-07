#!/bin/bash

source src/auth.sh

access_token_file="tests/tmp/access_token.json"
client_secret_file="${HOME}/.google/client_secret.json"

#rm -fr "${access_token_file}"

google_calendar_script_auth "${access_token_file}" "${client_secret_file}"
