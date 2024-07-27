#!/bin/bash
service tor start # runs as user debian-tor
exec sudo -H -u www-data bitcoind -conf=/config/bitcoind.conf # running as user www-data
