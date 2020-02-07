FROM node:10

LABEL maintainer="info@thorstenreichelt.de"

RUN  apt-get update && apt-get install -y \
	build-essential \
	locales \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
    && \dpkg-reconfigure --frontend=noninteractive locales \
    && \update-locale LANG=de_DE.UTF-8
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

RUN mkdir /pimatic-app
RUN /usr/bin/env node --version
RUN cd / && npm install pimatic@latest --prefix pimatic-app --production

RUN cd /pimatic-app/node_modules/pimatic && npm link

COPY config_default.json /pimatic-app/config.json
RUN touch /pimatic-app/pimatic-daemon.log

ENTRYPOINT cd /pimatic-app && pimatic.js start && tail -f pimatic-daemon.log

USER pimatic
EXPOSE 80
VOLUME ["/pimatic-app"]
