ARG BASEIMAGE=node:14-slim
# hadolint ignore=DL3006
FROM ${BASEIMAGE}

ARG LOCALES_VERSION="2.24-11+deb9u4" 
ARG TZDATA_VERSION="2019c-0+deb9u1" 
ARG BUILD_VERSION="12.3" 

LABEL maintainer="info@thorstenreichelt.de"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    locales=${LOCALES_VERSION} \      
#    tzdata=${TZDATA_VERSION} \
    tzdata \
    build-essential=${BUILD_VERSION} \
    && sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
    && \dpkg-reconfigure --frontend=noninteractive locales \
    && \update-locale LANG=de_DE.UTF-8 \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apt-get autoremove -y \    
    && rm -rf /var/lib/apt/lists/*

ENV LANG="de_DE.UTF-8" \
    TZ="Europe/Berlin"

RUN groupadd pimatic \
	&& useradd -g pimatic -d /pimatic-app pimatic 

WORKDIR /
RUN mkdir /pimatic-app
ARG PIMATIC_VERSION="0.9.54" 
# hadolint ignore=DL3016
RUN npm install pimatic@${PIMATIC_VERSION} --prefix pimatic-app --production

RUN touch /pimatic-app/pimatic-daemon.log && ln -sf /dev/stdout /pimatic-app/pimatic-daemon.log

COPY config_default.json /pimatic-app/config.json

USER pimatic
EXPOSE 80
VOLUME ["/pimatic-app"]
ENTRYPOINT ["node", "/pimatic-app/pimatic.js start"]
