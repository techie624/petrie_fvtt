# Which OS base Image is being used
FROM ubuntu:18.04

# Update and install needed software
RUN apt-get update \
  && apt-get install -y vim git htop sudo sed wget curl libssl-dev unzip

# set up non-root user
RUN useradd -m gygax
#RUN echo -e "gary\ngary\n" | passwd gygax
RUN echo "gary\ngary\n" | passwd gygax
RUN sudo usermod -aG sudo gygax
RUN usermod --shell /bin/bash gygax
COPY .bashrc /home/gygax/
COPY .tmux.conf /home/gygax/
COPY .vimrc /home/gygax/

# Used just incase postgres is needed
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata

# Installing node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
RUN sudo apt install -y nodejs

# Install FoundryVTT
RUN mkdir /home/gygax/foundryvtt
RUN mkdir /home/gygax/foundrydata
# download file from google drive
RUN cd /home/gygax/foundryvtt/ && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1PpqMnrz1VAFC3hphHcVWlflIUNs7Q0Iv' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1PpqMnrz1VAFC3hphHcVWlflIUNs7Q0Iv" -O foundryvtt.zip && rm -rf /tmp/cookies.txt
RUN cd /home/gygax/foundryvtt/ && unzip /home/gygax/foundryvtt/foundryvtt.zip

CMD cd /home/gygax/foundryvtt/ && node resources/app/main.js --dataPath=$HOME/foundrydata