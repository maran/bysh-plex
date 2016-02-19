#! /bin/sh

useradd -u $USERID $USERNAME
sed -ibak "s/USERNAME/$USERNAME/" /etc/supervisor/conf.d/supervisord.conf
mkdir -p /config/logs/supervisor

rm -rf /var/run/*
rm -f "/config/Library/Application Support/Plex Media Server/plexmediaserver.pid"

mkdir -p /var/run/dbus
mkdir -p /config/logs/supervisor

touch /supervisord.log
touch /supervisord.pid
chown $USERNAME: /supervisord.log /supervisord.pid /config/logs/supervisor /data
chown messagebus:messagebus /var/run/dbus

dbus-uuidgen --ensure
dbus-daemon --system --fork
sleep 1

avahi-daemon -D
sleep 1

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
