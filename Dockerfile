FROM debian:wheezy

MAINTAINER Faisal Puthuparackat <faisal@druva.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C
ENV SALT_VERSION 2015.5.0+ds-1~bpo70+1


RUN echo "deb http://debian.saltstack.com/debian wheezy-saltstack-2015-05 main" > /etc/apt/sources.list.d/salt.list
ADD debian-salt-team-joehealy.gpg.key /tmp/debian-salt-team-joehealy.gpg.key
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
    && mkdir /etc/container_environment \
    && mkdir /etc/service && mkdir /etc/my_init.d \
    && apt-key add /tmp/debian-salt-team-joehealy.gpg.key \
    && rm /tmp/debian-salt-team-joehealy.gpg.key \
    && apt-get update && apt-get install -yq --no-install-recommends \
        salt-minion=${SALT_VERSION} vim ssh net-tools procps python3 python-setuptools git runit \
    && rm -rf /var/lib/apt/lists/* && apt-get clean \
    && cd /tmp && git clone https://github.com/docker/docker-py.git && cd docker-py && python setup.py install \
    && rm /usr/sbin/policy-rc.d

VOLUME /etc/salt
VOLUME /data

ADD salt-minion.runit /etc/service/salt-minion/run
ADD my_init /sbin/
RUN chmod a+x /etc/service/salt-minion/run /sbin/my_init

CMD ["/sbin/my_init"]