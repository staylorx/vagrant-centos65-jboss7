#!/usr/bin/env bash

#ensure these match the jboss-as script in /etc/init.d
export JBOSS_HOME=/opt/jboss-as
export JBOSS_USER=jboss

echo 'installing wget and curl...'
yum -y install wget curl

echo 'installing openjdk7...'
yum -y install java-1.7.0-openjdk-devel

echo 'getting the jboss gz...'
rm -rf jboss-as-7.1.1.Final.tar*
wget -q http://10.0.2.2:8081/artifactory/ext-release-local/com.redhat/jboss/jboss-as/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz

echo 'untarring jboss...'
tar xfz jboss-as-7.1.1.Final.tar.gz
rm -rf jboss-as-7.1.1.Final.tar.gz

echo 'moving it out to /opt'
rm -rf ${JBOSS_HOME}
mv jboss-as-7.1.1.Final ${JBOSS_HOME}

echo 'adding user and chown...'
adduser $JBOSS_USER -p password
chown -fR ${JBOSS_USER}.${JBOSS_USER} $JBOSS_HOME

echo 'tucking host jboss-as file into init.d'
cp /vagrant/provisioning/jboss-as /etc/init.d
chmod 744 /etc/init.d/jboss-as
chown root:root /etc/init.d/jboss-as

echo 'creating a jboss management password... unsecure!'
su $JBOSS_USER
cd $JBOSS_HOME/bin
./add-user.sh admin password
./standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0&

echo 'mgmt console: http://10.0.2.15:9990/console'
echo 'root app: http://10.0.2.15:8080/'

#to stop
#./jboss-cli.sh --connect --controller=127.0.0.1:9999 command=:shutdown