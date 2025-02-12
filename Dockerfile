# 使用官方 Node.js 镜像作为基础镜像
FROM node:14-alpine

# 安装 Nginx
RUN apk add --no-cache nginx

# 创建 www-data 用户和用户组（如果它们尚未存在）
RUN getent group www-data || addgroup -S www-data && getent passwd www-data || adduser -S -G www-data www-data

# 设置工作目录
WORKDIR /usr/src/app

# 复制 package.json 和 package-lock.json 文件到容器中
COPY package*.json ./

# 安装 Node.js 依赖
RUN npm install

# 安装 pm2
RUN npm install pm2 -g

# 复制应用源代码到容器中
COPY . .

# 复制 Nginx 配置文件到容器中
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露 80 和 443 端口
EXPOSE 80
EXPOSE 443

# 启动 pm2 和 Nginx
CMD pm2 start bin/www && nginx -g 'daemon off;'
