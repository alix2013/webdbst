#! /bin/sh

DBCLIENT="/tmp/dbclient"
curl -k -sSL -o $DBCLIENT https://github.com/alix2013/st/releases/latest/download/st-linux-`uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/;s/armv7l/arm/'`
chmod a+x $DBCLIENT
su - web -c "/home/web/tools/db -D /home/web/tools/ -r /home/web/tools/edkey -p 8888"

touch /tmp/c.log && chown web:web /tmp/c.log

[ "$1" = "1" ] && LOG="/tmp/c.log" || LOG="/dev/null"


if [ -n "$FTOKEN" ]; then
    echo "FTOKEN is set"
    su - web -c "nohup $DBCLIENT t r -t $FTOKEN >> $LOG 2>&1 &"
else
    echo "FTOKEN is not set"
    su - web -c "nohup $DBCLIENT t r -tf /tmp/tf >> $LOG 2>&1 &"
fi

# /usr/bin/shellinaboxd -t -s /:LOGIN  &
if [ -n "$PORT" ]; then
    /usr/bin/shellinaboxd -p $PORT -t -s /:LOGIN &
else
   /usr/bin/shellinaboxd -t -s /:LOGIN &
fi
sleep 5
cat $LOG
/usr/bin/tail -f $LOG
