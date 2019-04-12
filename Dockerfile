FROM debian

LABEL maintainer="info@thorstenreichelt.de"

# preparation
RUN apt-get install -y curl build-essential git wget

#nodejs installation
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
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
CMD  service pimatic start 

# expose port
EXPOSE 80
