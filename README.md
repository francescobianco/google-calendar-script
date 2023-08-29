# Calendar Scripts

Execute custom user scripts on calendar events.

## Installation

Clone the repository in `/opt/calendar-script` and add the following line to your crontab:

```shell
sudo git clone https://github.com/francescobianco/calendar-script /opt/calendar-script
```

Authorize the application to access your Google Calendar:

```shell
/usr/bin/bash /opt/calendar-script/calendar-script.sh --auth
```

Synchronize Google Calendar on you local machine:

```shell
/usr/bin/bash /opt/calendar-script/calendar-script.sh --sync
```

Add scheduled tasks to your crontab:

```shell
crontab -e
```

```crontab
* * * * * /usr/bin/bash /opt/calendar-script/calendar-script.sh --cron 
```

## Configuration

Customize the function `calendar_script` in `calendar-script.sh` to execute your custom scripts.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
