# Use an official Node.js runtime as a parent image
FROM node:18-alpine as build

# Set the working directory to /app
WORKDIR /app
ENV NODE_ENV production

# Copy package.json and package-lock.json to the container
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the app source code to the container
COPY . .

# Build the app
RUN yarn build

# Serve the app with Nginx
FROM node:18-alpine

WORKDIR /app

ENV NODE_ENV production

RUN yarn global add serve

COPY --from=build /app/build ./build

EXPOSE 3000

CMD ["serve", "-s", "build"]