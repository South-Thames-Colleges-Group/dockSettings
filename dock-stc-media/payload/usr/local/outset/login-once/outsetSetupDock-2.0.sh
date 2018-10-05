#!/bin/bash

source "/Library/STCG/Dock/ADgroups.txt"

studentDock="/Library/STCG/Dock/studentDock.txt"
staffDock="/Library/STCG/Dock/staffDock.txt"
dockUtil="/usr/local/bin/dockutil"

if id -Gn | grep -q -w "$STCstudent";
then
    echo "-- $USER is a student --";
    "$dockUtil" --remove all -v
    sleep 1
    while sD='' read -r line || [[ -n "$line" ]]
    do
		echo "-- Adding" "$line" "--"
	    "$dockUtil" --add "$line" --no-restart -v
        sleep 1
    done < "$studentDock"

    "$dockUtil" --add '/Applications/Network Files' --view list --display folder -v
    "$dockUtil" --add "$HOME/Downloads" --view list --display folder --sort dateadded -v
elif id -Gn | grep -q -w "STCstaff";
then
    echo "-- $USER is a member of staff --"
    "$dockUtil" --remove all
    sleep 1
    while sD='' read -r line || [[ -n "$line" ]]
    do
		echo "-- Adding" "$line" "--"
	    "$dockUtil" --add "$line" --no-restart -v
        sleep 1
    done < "$staffDock"

    "$dockUtil" --add "/Applications/Microsoft Windows.rdp" --no-restart -v
    "$dockUtil" --add '/Applications/Network Files' --view list --display folder -v
    "$dockUtil" --add "$HOME/Downloads" --view list --display folder --sort dateadded -v
else
    echo "-- Not a student or staff memeber --";
fi

exit 0
