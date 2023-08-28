# Calendar Scripts

Execute custom user scripts on calendar events.

## Installation

Clone the repository in `/opt/calendar-scripts` and add the following line to your crontab:

```shell
sudo git clone https://github.com/francescobianco/calendar-scripts /opt/calendar-scripts
```

Authorize the application to access your Google Calendar:

```shell
/opt/calendar-scripts/calendar-scripts.sh --auth
```

Add scheduled tasks to your crontab:

```shell
crontab -e
```

```crontab
* * * * * /usr/bin/bash /opt/calendar-scripts/calendar-scripts.sh 
```
