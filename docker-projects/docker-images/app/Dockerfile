# ---------- STAGE 1: Build & install dependencies ----------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install ONLY production dependencies
COPY package*.json ./
RUN npm install --production


# ---------- STAGE 2: Runtime image (smaller, non-root, hardened) ----------
FROM node:20-alpine

WORKDIR /app

# Copy only what we need from the builder image
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Environment for production
ENV NODE_ENV=production

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose app port
EXPOSE 3000

# Healthcheck to monitor container status
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1:3000/ || exit 1

# Start the app
CMD ["node", "server.js"]
