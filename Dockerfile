# Stage 1: Install and build the Next.js app
FROM node:18-alpine AS build

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: Serve the app with minimal image size
FROM node:18-alpine AS production

WORKDIR /app

# Copy built files from the build stage
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package.json ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port
EXPOSE 3000

# Set environment variables for Next.js
ENV NODE_ENV=production

# Start the Next.js app
CMD ["npm", "run", "start"]
