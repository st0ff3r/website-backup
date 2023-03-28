#
# uIota Dockerfile
#
# The resulting image will contain everything needed to build uIota FW.
#
# Setup: (only needed once per Dockerfile change)
# 1. install docker, add yourself to docker group, enable docker, relogin
# 2. # docker build -t uiota-build .
#
# Usage:
# 3. cd to MeterLoggerWeb root
# 4. # docker run -t -i -p 8080:80 meterloggerweb:latest


FROM debian:buster

MAINTAINER Kristoffer Ek <stoffer@skulp.net>

RUN "echo" "deb http://http.us.debian.org/debian buster non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
	aptitude \
	apt-utils \
	autoconf \
	automake \
	aptitude \
	bash \
	sshfs \
	rsnapshot \
	default-mysql-client \
	cpp \
	gcc \
	libc-dev-bin \
	libc6-dev \
	git \
	inetutils-telnet \
	joe \
	make \
	linux-libc-dev \
	mime-support \
	sed \
	texinfo \
	sudo \
	screen \
	rsync \
	wget \
	python3 \
	python3-venv \
	procps \
	kpartx \
	cmake

RUN adduser --disabled-password --gecos "" debian && usermod -a -G dialout debian
RUN usermod -a -G sudo debian
RUN perl -pi.orig -e 's/(\%sudo\s+ALL\s*=\s*)\(ALL:ALL\)\s+ALL/$1\(ALL\) NOPASSWD: ALL/' /etc/sudoers

COPY ssh/. /home/debian/.ssh/
COPY rsnapshot.conf /etc/rsnapshot.conf
COPY rsnapshot_cron /etc/cron.d/rsnapshot
COPY rsnapshot.log /var/log/rsnapshot.log
COPY mysqldump.cnf /etc/mysql/conf.d/mysqldump.cnf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chown -R debian:debian /home/debian/.ssh
RUN chown debian:debian /var/log/rsnapshot.log
RUN chmod 0644 /etc/cron.d/rsnapshot
RUN touch /var/log/cron.log

RUN ln -s /usr/bin/aclocal-1.16 /usr/bin/aclocal-1.15; ln -s /usr/bin/automake-1.16 /usr/bin/automake-1.15

USER debian

# build sshpass from source to let it read password from SSH_PASSWORD instead of SSHPASS
RUN cd ~ && git clone https://github.com/kevinburke/sshpass.git
RUN perl -pi.orig -e 's/args\.pwsrc\.password=getenv\("SSHPASS"\)/args\.pwsrc\.password=getenv\("SSH_PASSWORD"\)/' ~/sshpass/main.c
RUN	ln -s ~/sshpass/README.md ~/sshpass/README
RUN	cd ~/sshpass && ./configure && make && sudo make install
RUN rm -fr ~/sshpass

CMD /docker-entrypoint.sh

