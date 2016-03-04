# Ansible Tower Dockerfie

FROM ubuntu:14.04

MAINTAINER ybaltouski@gmail.com

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN echo 'export LC_ALL="en_US.UTF-8"' >> /root/.bashrc

RUN touch /etc/default/locale
RUN echo 'LANG="en_US.UTF-8"' >> /etc/default/locale
RUN echo 'LANGUAGE="en_US:en"' >> /etc/default/locale


ENV ANSIBLE_TOWER_VER 2.4.1
ENV PG_DATA /var/lib/postgresql/9.4/main

RUN apt-get install -y software-properties-common \
    && apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y ansible

ADD http://releases.ansible.com/awx/setup/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz /opt/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz

RUN cd /opt && tar -xvf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && rm -rf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && mv ansible-tower-setup-${ANSIBLE_TOWER_VER} /opt/tower-setup


ADD tower_setup_conf.yml /opt/tower-setup/tower_setup_conf.yml
ADD inventory /opt/tower-setup/inventory

RUN cd /opt/tower-setup \
    && ./setup.sh

VOLUME ${PG_DATA}
VOLUME /certs

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 443 8080

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["ansible-tower"]


