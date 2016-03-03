#!/bin/bash

if [ ! -f $content_dir/content-packs-installed ]; then
    echo "Forking process that will install any content packs"
    $script_dir/install-content-packs.sh &
fi

echo "Run graylog docker cmd ..."
/opt/graylog/embedded/share/docker/my_init
