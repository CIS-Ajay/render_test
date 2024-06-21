# Use selenium/node-chrome as a parent image
FROM selenium/node-chrome:latest

# Install Node.js and npm
FROM node:18
# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy app source code
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Run your application
CMD [ "node", "app.js" ]
