#!/bin/bash
# run on vm startup

set -e
[ -f /var/lib/lab6-ready ] && exit 0

apt-get update
apt-get install -y python3-venv python3-pip

python3 -m venv /opt/lab6-venv
/opt/lab6-venv/bin/pip install --upgrade pip
/opt/lab6-venv/bin/pip install flask pillow jsonpickle requests grpcio grpcio-tools
chmod -R a+rX /opt/lab6-venv

touch /var/lib/lab6-ready
