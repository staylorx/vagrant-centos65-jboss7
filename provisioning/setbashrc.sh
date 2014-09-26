#!/usr/bin/env bash

echo 'export JBOSS_HOME=/usr/share/jboss-as' >> .bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.65.x86_64' >> .bashrc
echo 'export PATH=$JAVA_HOME:$PATH' >> .bashrc
touch .bashrc