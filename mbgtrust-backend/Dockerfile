FROM node:22-bullseye

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies and generate Prisma Client
RUN npm ci
RUN npx prisma generate

# Copy the rest of the application
COPY . .

# Expose port (Railway will provide PORT automatically)
EXPOSE 3000

# Start command
CMD ["sh", "-c", "npx prisma migrate deploy && node src/server.js"]
