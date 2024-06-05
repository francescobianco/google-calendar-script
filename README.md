# 📅 Google Calendar Script

Execute custom user scripts on calendar events.

## 🚀 Installation

Clone the repository to `/opt/google-calendar-script`:

```shell
sudo git clone https://github.com/francescobianco/google-calendar-script /opt/google-calendar-script
```

Authorize the application to access your Google Calendar:

```shell
/usr/bin/bash /opt/google-calendar-script/bin/google-calendar-script.sh --auth
```

Add scheduled tasks to your crontab:

```shell
crontab -e
```

```crontab
* * * * * /usr/bin/bash /opt/google-calendar-script/bin/google-calendar-script --cron 
```

Create a file named `calendar-script.sh` in `~/.google/` with instructions to execute when a calendar event is triggered.

## ⚙️ Configuration

Customize the file `~/.google/calendar-script.sh` to execute your custom scripts.

The following environment variables are available:

- `$GOOGLE_CALENDAR_EVENT_SUMMARY`: The event summary.
- `$GOOGLE_CALENDAR_EVENT_ID`: The event ID.
- `$GOOGLE_CALENDAR_EVENT_STATE`: The current state of the event.
- `$GOOGLE_CALENDAR_EVENT_STATE_TIME`: The time when the event state was updated.
- `$GOOGLE_CALENDAR_EVENT_START`: The start time of the event.
- `$GOOGLE_CALENDAR_EVENT_END`: The end time of the event.
- `$GOOGLE_CALENDAR_EVENT_REMINDER_1`: The first reminder time for the event.
- `$GOOGLE_CALENDAR_EVENT_REMINDER_2`: The second reminder time for the event.

The following event states are available for the `$GOOGLE_CALENDAR_EVENT_STATE` variable:

- `PENDING`: The event is pending.
- `REMINDED1`: The first reminder has been triggered.
- `REMINDED2`: The second reminder has been triggered.
- `STARTED`: The event has started.
- `ENDED`: The event has ended.
 


## 🔑 Setting up OAuth2 Credentials

1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one.
3. In the sidebar menu, navigate to "APIs & Services" > "Credentials".
4. Click on "Create Credentials" and select "OAuth client ID".
5. Choose "Desktop app" as the application type.
6. Name your OAuth 2.0 client and click "Create".
7. Once created, download the JSON file containing your client secret.
8. Rename the downloaded file to `client_secret.json` and place it in the `~/.google/` directory.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
