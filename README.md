# docker-nginx-php
Docker构建的dnmp环境

## 版本信息

- nginx-1.16
- php-7.1（常用扩展均已安装，如Swoole）
- php-fpm7.2
- mysql-5.6.45
- redis-5.0.6

## 使用

1. 在win10、macOS或者linux上安装好docker以及docker-compose

2. 下载本项目

```
git clone https://github.com/Coding-Yuan/docker-nginx-php.git
```

2. 启动容器

```
cd docker-nginx-php

docker-compose up -d
```

3. 可能遇到的问题

- 在Windows下work/nginx-php.sh脚本可能会出错，yml文件中注释了就行
- docker桌面版刚安装好，启动容器却找不到目录，可能是docker的共享磁盘没有开启

## 目录结构

```

.
├── README.md
├── app  // 应用程序存放目录
├── conf // 配置
│   ├── mysql // mysql配置
│   │   └── mysql.cnf
│   ├── nginx // nginx配置
│   │   ├── nginx.conf
│   │   └── vhost // 虚拟域名配置
│   └── php   // php7.1配置
│   |    └── www.conf
│   └── php72 // php7.2配置
│       └── www.conf
├── data // 数据挂载目录
│   ├── mysql // mysql相关数据文件
│   └── redis // redis相关数据文件
├── docker-compose.yml
├── logs // 日志目录
│   ├── mysql  // mysql日志
│   └── nginx  // nginx日志
└── work // 自定义脚本目录
    ├── mysql.sh // 更改mysql容器挂载目录的属主属户
    └── nginx-php.sh // 更改nginx-php容器挂载目录的属主属户

```

## 配置实例 - 创建一个yii2站点


1. composer安装yii2框架

```
cd ./app

php /usr/local/bin/composer create-project yiisoft/yii2-app-advanced blog

// 初始化Yii运行环境
cd blog

./init
```

2. 配置nginx

```
// 切换到docker-nginx-php根目录

vim conf/nginx/vhost/blog.local.com.conf
```

yii.local.com.conf内容：

```
server {
        listen 80;
        server_name blog.local.com;
        root        /data/wwwroot/blog/frontend/web/;
        index       index.php;

        access_log  /data/wwwlogs/blog.local.com_access.log;
        error_log   /data/wwwlogs/blog.local.com_error.log;

        location / {
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header Host $http_host;
           proxy_set_header X-NginX-Proxy true;
           # Redirect everything that isn't a real file to index.php
            try_files $uri $uri/ /index.php$is_args$args;
        }

        # deny accessing php files for the /assets directory
        location ~ ^/assets/.*\.php$ {
            deny all;
        }

        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            # fastcgi_pass 127.0.0.1:9000;
            # fastcgi_pass php72:9000; // 如需php7.2版本，开启此项
            fastcgi_pass unix:/dev/shm/php-cgi.sock;
            try_files $uri =404;
        }

        location ~* /\. {
            deny all;
        }
}
```

3. 添加hosts（有云主机的同学，这一步添加域名解析即可）

```
sudo vim /etc/hosts
```

```
127.0.0.1 blog.local.com
```

4. 访问 http://blog.local.com

```
Congratulations!
```

