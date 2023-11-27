FROM node:latest
WORKDIR /app
COPY server.js .
CMD ["node", "server.js"]
EXPOSE 8080
