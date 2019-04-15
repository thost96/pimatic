FROM debian:latest

LABEL maintainer="info@thorstenreichelt.de"

# preparation
RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  git \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Configure locales/ language/ timezone
# RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
#     && \dpkg-reconfigure --frontend=noninteractive locales \
#     && \update-locale LANG=de_DE.UTF-8
# RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

#nodejs installation
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y \
  nodejs \
  && rm -rf /var/lib/apt/lists/*
RUN /usr/bin/env node --version

# pimatic installaton
RUN mkdir /pimatic-app
RUN npm install pimatic@latest --prefix pimatic-app --production
RUN cp /pimatic-app/node_modules/pimatic/config_default.json /pimatic-app/config.json 

# install globally
RUN cd /pimatic-app/node_modules/pimatic && npm link

# addd autostart
WORKDIR /
RUN wget https://raw.githubusercontent.com/pimatic/pimatic/v0.9.x/install/pimatic-init-d && cp pimatic-init-d /etc/init.d/pimatic
RUN chmod +x /etc/init.d/pimatic
RUN chown root:root /etc/init.d/pimatic
RUN update-rc.d pimatic defaults

# adding plugins
# WORKDIR /pimatic-app
# RUN npm install pimatic-shell-execute
# RUN npm install pimatic-homeduino

# cleaning up
RUN rm -rf /pimatic-init-d

# start pimatic service
CMD  pimatic.js start 

# expose port
EXPOSE 80
