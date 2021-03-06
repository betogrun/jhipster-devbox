#!/bin/sh

# update the system
apt-get update
apt-get upgrade

################################################################################
# This is a port of the JHipster Dockerfile,
# see https://github.com/jhipster/jhipster-docker/
################################################################################

export JAVA_VERSION='8'
export JAVA_HOME='/usr/lib/jvm/java-8-oracle'

export MAVEN_VERSION='3.3.9'
export MAVEN_HOME='/usr/share/maven'
export PATH=$PATH:$MAVEN_HOME/bin

export LANGUAGE='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# install utilities
apt-get -y install vim git zip bzip2 fontconfig curl

# install Java 8
echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

apt-get update

echo oracle-java-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install -y --force-yes oracle-java${JAVA_VERSION}-installer
 update-java-alternatives -s java-8-oracle

# install maven
curl -fsSL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar xzf - -C /usr/share && mv /usr/share/apache-maven-${MAVEN_VERSION} /usr/share/maven && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# install node.js
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs unzip python g++ build-essential

# update npm
npm install -g npm

# install yeoman grunt bower grunt gulp
npm install -g yo bower grunt-cli gulp

# install JHipster
npm install -g generator-jhipster@3.0.0

# install JHipster UML
npm install -g jhipster-uml@1.6.4

################################################################################
# Install the graphical environment
################################################################################

# force encoding
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

# install languages
apt-get install -y language-pack-fr

# run GUI as non-privileged user
echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config

# install Ubuntu desktop and VirtualBox guest tools
apt-get install -y ubuntu-desktop virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
apt-get install -y gnome-session-flashback

################################################################################
# Install the development tools
################################################################################

# install Spring Tool Suite
export STS_VERSION='3.7.2.RELEASE'

cd /opt && wget  http://dist.springsource.com/release/STS/${STS_VERSION}/dist/e4.5/spring-tool-suite-${STS_VERSION}-e4.5.1-linux-gtk-x86_64.tar.gz
cd /opt && tar -zxvf spring-tool-suite-${STS_VERSION}-e4.5.1-linux-gtk-x86_64.tar.gz
cd /opt && rm -f spring-tool-suite-${STS_VERSION}-e4.5.1-linux-gtk-x86_64.tar.gz
chown -R vagrant:vagrant /opt
cd /home/vagrant

# install Chromium Browser
apt-get install -y chromium-browser

# install MySQL Workbench
apt-get install -y mysql-workbench

# install MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update

sudo apt-get install -y mongodb-org

# install PgAdmin
apt-get install -y pgadmin3

# install Heroku toolbelt
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# install Cloud Foundry client
cd /opt && curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
ln -s /opt/cf /usr/bin/cf
cd /home/vagrant

#install Guake
apt-get install -y guake
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

# install Atom

wget https://github.com/atom/atom/releases/download/v1.6.0/atom-amd64.deb
dpkg -i atom-amd64.deb
rm -f atom-amd64.deb
dpkg --configure -a

# install Docker
curl -sL https://get.docker.io/ | sh

# configure docker group (docker commands can be launched without sudo)
usermod -aG docker vagrant

# install docker compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# provide m2
mkdir -p /home/vagrant/.m2
git clone https://github.com/jhipster/jhipster-travis-build /home/vagrant/jhipster-travis-build
mv /home/vagrant/jhipster-travis-build/repository /home/vagrant/.m2/
rm -Rf /home/vagrant/jhipster-travis-build

# create shortcuts
mkdir /home/vagrant/Desktop
ln -s /opt/sts-bundle/sts-${STS_VERSION}/STS /home/vagrant/Desktop/STS
chown -R vagrant:vagrant /home/vagrant
echo 'alias sts=/opt/sts-bundle/sts-${STS_VERSION}/STS' >> /home/vagrant/.bashrc

# clean the box
apt-get clean
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
