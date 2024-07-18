FROM node:20

WORKDIR /app

COPY ./main/package*.json ./

RUN apt update && apt install -y vim
RUN npm install

COPY ./main .

CMD ["npm", "run", "dev"]