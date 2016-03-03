#!/bin/bash

USER='admin'
PASSWORD='admin'

if [ -n "$GRAYLOG_PASSWORD" ]; then
    PASSWORD=$GRAYLOG_PASSWORD
fi

echo "Waiting for Graylog webinterface...."
until $(curl --output /dev/null --silent --head --fail -u $USER:$PASSWORD http://localhost:12900/system); do
    echo 'Waiting some more...'
    sleep 5
done

echo "Graylog webinterface seems to be ready ready"
sleep 5 # Just to be safe... 

echo "---- system ----"
curl --silent -u $USER:$PASSWORD http://localhost:12900/system | jq '.'
echo "----------------"
echo ""

echo "---- service-manager ----"
curl --silent -u $USER:$PASSWORD http://localhost:12900/system/serviceManager | jq '.'
echo "-------------------------"
echo ""

for file in $content_dir/*.json; do
    echo "Installing content-pack: $file"; 
    uri=$(curl -s -v -u $USER:$PASSWORD -X POST -H "Content-Type: application/json" -d "@${file}" http://localhost:12900/system/bundles 2>&1 | grep "Location" | awk '{ print $3 }' | tr -d '\r')

    echo "Content pack uri: ${uri}"
    enableUri="${uri}/apply"

    echo "Enabling content-pack: ${enableUri}"
    curl -s -v -u $USER:$PASSWORD -X POST $enableUri
done

touch $content_dir/content-packs-installed
