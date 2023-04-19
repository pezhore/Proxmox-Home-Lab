#!/bin/env bash

# Download
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar &> lastdl.log && echo "Download Successful"

# Build
# use --rev version to overwrite latest with given argument else use latest
java -jar BuildTools.jar --rev ${1:-latest} &> lastbuild.log && echo "Build Successful"

# Backup
mv ../../server/spigot.jar ../../backup/server/`date +"%Y-%m-%H-spigot.jar"` && echo "Backup Successful"

# Install
mv spigot-1.*.jar ../../server/spigot.jar && echo "Install Successful"