# Google Calendar Script

Execute custom user scripts on calendar events.

## Installation

Clone the repository in `/opt/google-calendar-script` and add the following line to your crontab:

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

Create a file named `.google-calendar-script.sh` in `~/` with instructions to execute when a calendar event is triggered.

## Configuration

Customize the function `calendar_script` in `calendar-script.sh` to execute your custom scripts.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
