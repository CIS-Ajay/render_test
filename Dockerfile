# Stage 1: Build stage
FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy app source code
COPY . .

# Stage 2: Final stage with Chrome and Puppeteer dependencies
FROM selenium/node-chrome:latest

# Switch to root user to install dependencies
USER root

# Set the working directory in the container
WORKDIR /app

# Copy everything from the build stage
COPY --from=build /app /app

# Install additional dependencies for Puppeteer
RUN apt-get update && \
    apt-get install -y --fix-missing \
        wget \
        gnupg \
        libnss3 \
        libatk-bridge2.0-0 \
        libgtk-3-0 \
        libgbm-dev

# Add Google Chrome's signing key and repository
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

# Update package lists and install Google Chrome
RUN apt-get update && \
    apt-get install -y google-chrome-stable

# Switch back to non-root user
USER seluser

# Expose the port your app runs on
EXPOSE 3000

# Run your application
CMD ["node", "app.js"]
