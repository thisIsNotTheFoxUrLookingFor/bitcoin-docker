#!/bin/bash
exec sudo -H -u www-data bitcoind -conf=/config/bitcoind.conf
