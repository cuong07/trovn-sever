FROM node:20-slim

RUN apt-get update && apt-get install -y \
    libc6 \
    libgcc1 \
    libstdc++6 \
    libglib2.0-0 \
    libssl3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma

RUN npm install

# Copy source code và .env file
COPY . .

# Generate Prisma client
RUN npx prisma generate

EXPOSE 8891

CMD ["node", "index.js"]


# # ==========================================
# # HTTP cho trovn.io.vn → Client app
# # ==========================================
# server {
#     listen 80;
#     server_name trovn.io.vn;

#     location / {
#         proxy_pass http://localhost:5174;
#         proxy_set_header Host $host;
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto $scheme;
#     }
# }


# # ==========================================
# # HTTP cho api.trovn.io.vn → Sever
# # ==========================================
# server {
#     listen 80;
#     server_name api.trovn.io.vn;

#     location / {
#         proxy_pass http://localhost:8891;
#         proxy_set_header Host $host;
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto $scheme;
#     }
# }

#  715  sudo nginx -t
#   716  sudo systemctl reload nginx

#   docker build -t trovn-sever:latest .
#   870  docker run -d --name trovn-sever_container -p 8891:8891 trovn-sever:latest

