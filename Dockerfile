FROM node:14-slim

LABEL maintainer="info@thorstenreichelt.de"

RUN  apt-get update -qq && apt-get install -y -qq --no-install-recommends \
	locales=2.24-11+deb9u4 \
	tzdata=2019c-0+deb9u1 \
	build-essential \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
    && \dpkg-reconfigure --frontend=noninteractive locales \
    && \update-locale LANG=de_DE.UTF-8
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

ENV LANG="de_DE.UTF-8" \
    TZ="Europe/Berlin"

WORKDIR /
RUN mkdir /pimatic-app
RUN npm install pimatic@latest --prefix pimatic-app --production

RUN touch /pimatic-app/pimatic-daemon.log && ln -sf /dev/stdout /pimatic-app/pimatic-daemon.log

COPY config_default.json /pimatic-app/config.json

USER pimatic
EXPOSE 80
VOLUME ["/pimatic-app"]
ENTRYPOINT ["node", "/pimatic-app/pimatic.js start"]
