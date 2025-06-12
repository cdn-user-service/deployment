## Frontend 
npm run dev:cdn_users
npm run build:cdn_users

### 配置开发环境修改 

<!-- 单独跑前端 -->
- 添加 .env.development : `--NODE_ENV=development--` => `VUE_APP_ENV=development`

- 修改./src/utils/request.js
- 修改./src/utils/auth.js
- 修改./src/v2/cdn_users/router/index.js. (for cdn_user)

<!-- 连接前后端 -->
- 修改 vue.config.js 改为本地地址： `devServer:{proxy:{'/cdn_api':{target: 'http://localhost:18080',}}}`


### 功能增添路径 

- user首页【服务概览】- 增添近30天：src/v2/cdn_users/views/cdn/dashboard/components/LeftMonitor/index.vue


## Backend
mvn spring-boot:run

### 配置开发环境修改

远程server开放端口
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 6379 -j ACCEPT
想加output也可以


#### 添加mysql远程权限 

```
    GRANT ALL PRIVILEGES ON cdn.* TO 'root'@'%' IDENTIFIED BY '你的密码';
    GRANT ALL PRIVILEGES ON cdn.* TO 'root'@'127.0.0.1' IDENTIFIED BY '你的密码';
    FLUSH PRIVILEGES;
```
application.yml修改：
修改
```
server:
  port: 18080  # 因为后面配置了ssh通道本地是18080
spring:  
  profiles:
    active: dev
```
添加application-dev.yml
不知为何数据库和密码都不对
```
username: cdn
password: 见cat /root/.mysql_secret
```

#### 添加redis远程权限

在application-dev.yml中添加redis密码：
cat /usr/ants/redis-6.2.6/redis.conf ｜ grep “requirepass”

修改redis配置
添加`src/main/java/io/ants/common/utils/AppConfigHelper.java`页面
在`src/main/java/io/ants/common/utils/FileUtils.java`的`getRedisPassWord()`
添加：远程获取redis pwd
在`src/main/java/io/ants/CdnSysRunner.java`的`run`中
去掉 initCreateSyncConfig()


### 调试修改

修改日志`backend/src/main/resources/logback-spring.xml` 注意不是config里那个xml，调整dev的log为info
启动命令更改添加环境为dev 见⬇️启动

### 启动

```
# 建立ssh隧道
# mysql
autossh -M 0 -f -N -L 13306:127.0.0.1:3306 cdn-master
# redis
autossh -M 0 -f -N -L 16379:127.0.0.1:6379 cdn-master
# elasticsearch
autossh -M 0 -f -N -L 9200:127.0.0.1:9200 cdn-master
# kibana
autossh -M 0 -f -N -L 5601:127.0.0.1:5601 cdn-es

# 清除
mvn clean
# 启动
mvn spring-boot:run -Dspring-boot.run.profiles=dev
nohup mvn spring-boot:run > backend.log 2>&1 &
```

### 功能增添路径

