#!/usr/bin/env bash
set -e

sanitize_utf8() {
  local text="$1"
  local regex='[^[:alnum:][:space:][:punct:]]'
  echo "$text" | LC_CTYPE=C sed -e "s/$regex//g"
}

today_agenda=~/.today_agenda
today_agenda_alert=~/.today_agenda_alert

[ ! -f "$today_agenda" ] && touch "$today_agenda"
[ ! -f "$today_agenda_alert" ] && touch "$today_agenda_alert"

now=$(date +%s)
refresh_interval=10000
post_update=$((now - refresh_interval))
last_update=$(stat -c %Y "$today_agenda")
today=$(date +%Y-%m-%d)

if [ "$last_update" -le "$post_update" ]; then
  gcalcli agenda --tsv "${today} 00:00" "${today} 23:59" > "$today_agenda"
  sed -i "/^${today/-/\-}/!d" "${today_agenda_alert}"
fi

while read -r event; do
  notify=1
  event_time=$(date -d "$today $(cut -f2 <<< "$event")" +%s)
  event_summary=$(cut -f5 <<< "$event")
  while read -r alert; do
    if [ "$event" = "$alert" ]; then
      notify=0
      break
    fi
  done < "$today_agenda_alert"
  if [ "$notify" -eq 0 ]; then
    continue
  fi
  if [ "$event_time" -le "$now" ]; then
    linepush "$(sanitize_utf8 "$event_summary")"
    one-thing "$event_summary"
    echo -e "$event" >> $today_agenda_alert
  fi
done < "$today_agenda"
