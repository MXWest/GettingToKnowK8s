FROM node:6.9.5
EXPOSE 8080
COPY server.js .
CMD node server.js
