#!/bin/bash
SERVICE='php5-fpm'
if P=$(pgrep $SERVICE)
then
    echo "$SERVICE is running, PID is $P. Stopping service..."
	service php5-fpm stop
else
    echo "$SERVICE is not running"
fi

SERVICE='nginx'
if P=$(pgrep $SERVICE)
then
    echo "$SERVICE is running, PID is $P. Stopping service..."
	service nginx stop
else
    echo "$SERVICE is not running"
fi
