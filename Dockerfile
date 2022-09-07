# Which OS base Image is being used
FROM ubuntu:latest

# Update and install needed software
RUN apt-get update && \
  apt-get install -y vim git htop sudo sed wget curl libssl-dev unzip telnet net-tools snapd nginx

# set up non-root user
RUN useradd -m gygax
RUN echo "gary\ngary\n" | passwd gygax
RUN sudo usermod -aG sudo gygax
RUN usermod --shell /bin/bash gygax
COPY .bashrc /home/gygax/
COPY .tmux.conf /home/gygax/
COPY .vimrc /home/gygax/

# Used just incase postgres is needed
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata

# Installing node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN sudo apt install -y nodejs

# Install FoundryVTT
# download file from google drive
#RUN cd /home/gygax/foundryvtt/ && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=18iV2MyGvkL7iaYsAekOwuUNnWMuNtl0I' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=18iV2MyGvkL7iaYsAekOwuUNnWMuNtl0I" -O foundryvtt.zip && rm -rf /tmp/cookies.txt


COPY foundryvtt/ /home/gygax/foundryvtt/

COPY options.json /root/foundrydata/Config/

COPY fvtt.ethorians.net /etc/nginx/sites-available/
RUN sudo unlink /etc/nginx/sites-enabled/default
RUN sudo ln -s /etc/nginx/sites-available/fvtt.ethorians.net /etc/nginx/sites-enabled/
#RUN service nginx start

CMD cd /home/gygax/foundryvtt/ && node resources/app/main.js --dataPath=$HOME/foundrydata
