FROM node:12.4.0-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN yarn --ignore-engines

# COPY maps/releases/latest/maps.json ./src/data/maps.json
COPY src ./src
COPY index.html webpack.config.js .babelrc ./

EXPOSE 8080
CMD ["npm", "start"]
