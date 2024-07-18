FROM node:20

WORKDIR /app

COPY package*.json ./

RUN apt update && apt install -y vim
RUN npm install

COPY . .

CMD ["npm", "run", "dev"]