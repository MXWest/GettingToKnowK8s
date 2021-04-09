FROM node:15.14.0
EXPOSE 8080
COPY server.js .
CMD node server.js
