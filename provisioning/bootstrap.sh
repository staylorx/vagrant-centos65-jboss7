#!/usr/bin/env bash

#ensure these match the jboss-as script in /etc/init.d
export JBOSS_HOME=/usr/share/jboss-as
export JBOSS_USER=jboss-as
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.65.x86_64

cd /etc/yum.repos.d
cp /vagrant/provisioning/yum.repos.d/* .
cd

echo 'installing wget curl openjdk...'
yum -y -d1 install wget curl java-1.7.0-openjdk-devel

echo 'getting the jboss gz...'
rm -rf jboss-as-7.1.1.Final.tar*
wget -q http://10.0.2.2:8881/nexus/content/repositories/jboss-download/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz

echo 'untarring jboss...'
tar xfz jboss-as-7.1.1.Final.tar.gz
rm -rf jboss-as-7.1.1.Final.tar.gz

echo 'moving it out to /opt'
rm -rf ${JBOSS_HOME}
mv jboss-as-7.1.1.Final ${JBOSS_HOME}

# copy configs with 0.0.0.0 and the like
cd $JBOSS_HOME
cp -fR /vagrant/provisioning/domain .
cp -fR /vagrant/provisioning/standalone .
chown -fR root:root $JBOSS_HOME

echo 'add the mgmt admin user'
java -jar ${JBOSS_HOME}/jboss-modules.jar -mp ${JBOSS_HOME}/modules org.jboss.as.domain-add-user --silent=true admin adminPass1!

echo 'adding user and chown...'
adduser $JBOSS_USER
chown -fR ${JBOSS_USER}.${JBOSS_USER} $JBOSS_HOME
su - $JBOSS_USER -c '/vagrant/provisioning/setbashrc.sh'

echo 'copying standalone service file into init.d'
cd /etc/init.d
cp ${JBOSS_HOME}/bin/init.d/jboss-as-standalone.sh jboss-as
chmod 0755 /etc/init.d/jboss-as

#the /etc/init.d script needs this config file... added JAVA_HOME and JBOSS_HOME already.
mkdir /etc/jboss-as
cd /etc/jboss-as
cp /vagrant/provisioning/jboss-as.conf .
chmod 0744 /etc/jboss-as/jboss-as.conf
cd

chkconfig --add jboss-as
service jboss-as restart