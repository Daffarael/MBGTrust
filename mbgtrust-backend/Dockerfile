# Gunakan image Node.js versi 22 yang memenuhi syarat Prisma
FROM node:22-bookworm-slim

# Install OpenSSL (dibutuhkan oleh Prisma)
RUN apt-get update -y && apt-get install -y openssl

# Set working directory di dalam container
WORKDIR /app

# Copy file package.json dan package-lock.json
COPY package*.json ./

# Install dependensi aplikasi
RUN npm ci

# Copy seluruh source code backend
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# Expose port (biasanya Railway menggunakan port dari ENV, tapi ini sebagai dokumentasi)
EXPOSE 3000

# Perintah yang dijalankan saat aplikasi start
CMD ["sh", "-c", "npx prisma migrate deploy && node src/server.js"]
