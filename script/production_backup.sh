#!/bin/bash -e

echo "--> Starting backup on the server"
heroku pg:backups capture

echo "--> Fetching postgres backup"
curl -o present_backup.dump `heroku pg:backups public-url`

echo "--> Restoring backup to local postgres as `present_backup`"
createdb present_backup || true
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U `whoami` -d present_backup present_backup.dump || true

echo "All done!"
echo "Don't forget to set your database.yml to point to the 'present_backup' db!"
