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
* * * * * /usr/bin/bash /opt/google-calendar-script/bin/google-calendar-script.sh --cron 
```

Create a file named `calendar-script.sh` in `~/.google/` with instructions to execute when a calendar event is triggered.

## ⚙️ Configuration

Customize the function `calendar_script` in `calendar-script.sh` to execute your custom scripts.

## 🔑 Setting up OAuth2 Credentials

1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one.
3. In the sidebar menu, navigate to "APIs & Services" > "Credentials".
4. Click on "Create Credentials" and select "OAuth client ID".
5. Choose "Desktop app" as the application type.
6. Name your OAuth 2.0 client and click "Create".
7. Once created, download the JSON file containing your client secret.
8. Rename the downloaded file to `client_secret.json` and place it in the `credentials` directory of the Google Calendar Script repository.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
