#!/bin/bash
apt update -yq && apt upgrade -yq
sh /config/tc.sh
exec supervisord -c /config/supervisord.conf -n
