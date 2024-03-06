FROM node:20.8.1
WORKDIR /usr/app


COPY .  .

RUN npm ci --only--production

RUN npm run build

CMD [ "npm", 'start' ]