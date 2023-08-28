import requests
import re
import pandas as pd

# URL iCal del tuo calendario Google
ical_url = 'https://calendar.google.com/calendar/ical/info.francescobianco%40gmail.com/private-1015dd701af54a2a8f4bf6adeaf90468/basic.ics'

# Data per cui vuoi ottenere gli eventi (sostituisci con la data desiderata)
data_desiderata = '2023-09-04'

# Effettua la richiesta per ottenere il contenuto iCal
response = requests.get(ical_url)

print(response.text)

if response.status_code == 200:
    ical_content = response.text

    # Trova gli eventi per la data desiderata
    event_pattern = r'BEGIN:VEVENT.*?DTSTART;VALUE=DATE:' + data_desiderata + r'.*?END:VEVENT'
    events = re.findall(event_pattern, ical_content, re.DOTALL)

    if events:
        # Inizializza una lista per memorizzare gli eventi
        event_list = []

        # Estrai le informazioni degli eventi e aggiungile alla lista
        for event in events:
            event_info = {}
            event_info['Data'] = data_desiderata
            event_info['Ora Inizio'] = re.search(r'DTSTART:(.*?)\n', event).group(1)
            event_info['Ora Fine'] = re.search(r'DTEND:(.*?)\n', event).group(1)
            event_info['Titolo'] = re.search(r'SUMMARY:(.*?)\n', event).group(1)
            event_list.append(event_info)

        # Crea un DataFrame pandas con gli eventi
        df = pd.DataFrame(event_list)

        # Salva il DataFrame come CSV
        csv_filename = f'eventi_{data_desiderata}.csv'
        df.to_csv(csv_filename, index=False)

        print(f'Eventi salvati in {csv_filename}')
    else:
        print(f'Nessun evento trovato per la data {data_desiderata}')
else:
    print('Errore durante la richiesta del calendario iCal.')
