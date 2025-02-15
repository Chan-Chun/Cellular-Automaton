# Dockerfile 优化版
FROM node:14-alpine

# 安装依赖
RUN apk add --no-cache nginx certbot && \
    mkdir -p /var/www/html && \
    getent group www-data || addgroup -S www-data && \
    getent passwd www-data || adduser -S -G www-data -D www-data && \
    chown -R www-data:www-data /var/www/html

WORKDIR /app

COPY package*.json ./
RUN npm install && npm install pm2 -g

COPY . .

# 暴露端口
EXPOSE 80 443

# 启动命令
CMD ["sh", "-c", "pm2 start bin/www && nginx -g 'daemon off;'"]