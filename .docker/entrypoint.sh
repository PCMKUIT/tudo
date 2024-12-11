echo
echo
echo "-=-=-=-[ TUDO ]-=-=-=-"
echo 
echo 

# start and configure psql server
/etc/init.d/postgresql start
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = 'tudo'" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE tudo"
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres'"
sudo -u postgres psql -d tudo -c "SELECT 1 FROM setup_complete WHERE completed = TRUE" || sudo -u postgres psql -f /app/setup.sql tudo

# start cron
/etc/init.d/cron start

# start apache server
if ! pgrep -x "apache2" > /dev/null; then
    echo "Starting Apache server..."
    /usr/sbin/apache2ctl -D FOREGROUND
else
    echo "Apache is already running"
fi

# stayin alive
/bin/bash -c 'while [[ 1 ]]; do sleep 60; done';
