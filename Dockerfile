FROM graylog2/allinone

MAINTAINER gdubina@dataart.com

ENV content_dir /opt/restcomm-content
ADD content-packs $content_dir

ENV script_dir /opt/import-scripts

ADD files $script_dir

CMD $script_dir/run.sh
