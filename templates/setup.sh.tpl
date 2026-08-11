#!/bin/bash

echo "Server ${server_name}"

echo "Environment ${environment}"

apt-get update -y
apt-get install -y nginx
