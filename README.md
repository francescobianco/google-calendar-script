# Calendar Scripts

Execute custom user scripts on calendar events.

## Installation

Clone the repository in `/opt/calendar-script` and add the following line to your crontab:

```shell
sudo git clone https://github.com/francescobianco/calendar-script /opt/calendar-script
```

Authorize the application to access your Google Calendar:

```shell
/opt/calendar-script/calendar-script.sh --auth
```

Add scheduled tasks to your crontab:

```shell
crontab -e
```

```crontab
* * * * * /usr/bin/bash /opt/calendar-script/calendar-script.sh  --cron 
```
