#!/usr/bin/env bash

#ensure these match the jboss-as script in /etc/init.d
export JBOSS_HOME=/usr/share/jboss-as
export JBOSS_USER=jboss-as

echo 'creating a jboss management password... bad password!'
cd $JBOSS_HOME/bin
./add-user.sh admin adminPass1!