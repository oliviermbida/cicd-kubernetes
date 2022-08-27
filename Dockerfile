#
# CI development environment
#
FROM node:16.15-alpine3.14
LABEL maintainer="Olivier Mbida <oliver.mbida@ai-uavsystems.com>"

WORKDIR /app
RUN adduser -S app
COPY app/ .
RUN npm install
RUN npm install --save pm2@5.2.0
RUN chown -R app /app
USER app
EXPOSE 3000
CMD [ "npm", "run", "pm2" ]