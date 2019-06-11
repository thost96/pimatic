FROM node:4

LABEL maintainer="info@thorstenreichelt.de"

### Preparation
# RUN  apt install -y \
#  build-essentials \
#  && rm -rf /var/lib/apt/lists/*

# Configure locales/ language/ timezone
# RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
#     && \dpkg-reconfigure --frontend=noninteractive locales \
#     && \update-locale LANG=de_DE.UTF-8
# RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

### Pimatic Install
RUN mkdir /pimatic-app
RUN /usr/bin/env node --version
RUN cd / && npm install pimatic@latest --prefix pimatic-app --production

### Global install
RUN cd /pimatic-app/node_modules/pimatic && npm link

### Config copy
COPY config_default.json /pimatic-app/config.json
RUN touch /pimatic-app/pimatic-daemon.log

### Service start and tail logfile
ENTRYPOINT cd /pimatic-app && pimatic.js start && tail -f pimatic-daemon.log

### Expose port 80
EXPOSE 80
