# STCG Dock Settings

This project creates docks that are used in rooms throughout the college group.

This will no longer be done with pkgs deployed to the Macs, but just an outset script run with Jamf.

Requirements

- git
- munkipkg
- outset

## How to create a new dock

- Open the terminal and change directory
- Use munkipkg to create a new folder
- Use the following naming convention dock-site-room, or dock-site-department
- Edit settings in build-info.plist
- Create `payload/Library/STCG/Dock/staffDock.txt`
- Create `payload/Library/STCG/Dock/studentDock.txt`
- Create `payload/usr/local/outset/login-once/outsetSetupDock-1.0.sh`
- Fill in the appropriate infomation into each file
- Create the installer `munkipkg . --export`

## staffdock.txt and studentdock.txt

Example file:

```
/Applications/Launchpad.app
/Applications/Safari.app
/Applications/Google Chrome.app
/Applications/Photos.app
/Applications/Microsoft Excel.app
/Applications/Microsoft Word.app
/Applications/Microsoft PowerPoint.app
/Applications/Microsoft OneNote.app
/Applications/Adobe Bridge CC 2018/Adobe Bridge CC 2018.app
/Applications/Adobe Illustrator CC 2018/Adobe Illustrator.app
/Applications/Adobe InDesign CC 2018/Adobe InDesign CC 2018.app
/Applications/Adobe Photoshop CC 2018/Adobe Photoshop CC 2018.app
/Applications/Adobe Premiere Pro CC 2018/Adobe Premiere Pro CC 2018.app
```

## outsetSetupDock-1.0.sh

Example file:

```
#!/bin/bash

source "/Library/STCG/Dock/ADgroups.txt"

if id -Gn | grep -q -w "$KCstudent";
then
    echo "-- $USER is a student --";
    /usr/local/bin/dockutil --remove all -v
    sleep 1
    while sD='' read -r line || [[ -n "$line" ]]
    do
		echo "-- Adding" "$line" "--"
	    /usr/local/bin/dockutil --add "$line" --no-restart -v
        sleep 1
    done < /Library/STCG/Dock/studentDock.txt

    /usr/local/bin/dockutil --add '/Applications/Network Files' --view list --display folder -v
    /usr/local/bin/dockutil --add "$HOME/Downloads" --view list --display folder --sort dateadded -v
elif id -Gn | grep -q -w "KCstaff";
then
    echo "-- $USER is a member of staff --"
    /usr/local/bin/dockutil --remove all
    sleep 1
    while sD='' read -r line || [[ -n "$line" ]]
    do
		echo "-- Adding" "$line" "--"
	    /usr/local/bin/dockutil --add "$line" --no-restart -v
        sleep 1
    done < /Library/STCG/Dock/staffDock.txt

    /usr/local/bin/dockutil --add "/Applications/Microsoft Windows.rdp" --no-restart -v
    /usr/local/bin/dockutil --add '/Applications/Network Files' --view list --display folder -v
    /usr/local/bin/dockutil --add "$HOME/Downloads" --view list --display folder --sort dateadded -v
else
    echo "-- Not a student or staff memeber --";
fi

exit 0

```