FROM node:8

LABEL maintainer="info@thorstenreichelt.de"

# pimatic installaton
RUN mkdir /home/pimatic-app
RUN /usr/bin/env node --version
RUN cd /home && npm install pimatic --prefix pimatic-app --production

# instal globally
RUN cd /home/pimatic-app/node_modules/pimatic && npm link

# autostart
RUN wget https://raw.githubusercontent.com/pimatic/pimatic/v0.9.x/install/pimatic-init-d && cp pimatic-init-d /etc/init.d/pimatic
RUN chmod +x /etc/init.d/pimatic
RUN chown root:root /etc/init.d/pimatic
RUN update-rc.d pimatic defaults

# link the persistent config.json file and start the pimatic service
CMD ln -s /home/pimatic-app/configMount/config.json /home/pimatic-app/config.json && service pimatic start 

# expose pimatic port
EXPOSE 80
