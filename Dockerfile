FROM node:20

WORKDIR /app

RUN ls -alF /app

RUN apt update && apt install -y vim
RUN npm install -g npm@10.8.2

# gitに追記
RUN echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc
# git push --set-upstream originを入力するのがめんどくさい
# RUN git config --global push.default current

CMD ["npm", "run", "dev"]
# CMD ["bash"]
