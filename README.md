# spring-boot-admin-jenkins-docker
- 简介：使用`Jenkins`和`Docker`持续集成java项目，本例是Spring boot admin项目，较为简单，可做为参考。
- 意义：`Jenkinsfile`和`Dockerfile`将服务器设置和运维代码化、可视化、流程化、标准化，降低与其他人的沟通成本

## 安装Docker
参照官网安装：https://docs.docker.com/install/linux/docker-ce/centos/
> - 注意替换国内源加速，`https://download.docker.com/linux/`替换为`https://mirrors.aliyun.com/docker-ce/linux/`

配置阿里云镜像加速
```bash
$ sudo systemctl enable docker
$ sudo vi /etc/systemd/system/multi-user.target.wants/docker.service
$ #在文件中找到 ExecStart= 这一行，并且在其行尾添加上所需的配置。
$ #ExecStart=/usr/bin/dockerd --registry-mirror=https://c2iitbpy.mirror.aliyuncs.com
$ #加速器地址在阿里云管理控制台-容器服务-镜像-镜像仓库控制台-Docker Hub镜像站点中可以找到
$ #保存退出后，重新加载配置并启动服务：
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
$ #确认配置是否生效
$ sudo ps -ef | grep dockerd
```

## 安装Jenkins
运行Jenkins容器的命令
```bash
docker run \
  --name jenkins \
  -d \
  -u root \
  -p 8080:8080 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e TZ=Asia/Shanghai \
  -v "$HOME":/home \
  jenkinsci/blueocean
```
> - 使用命名卷管理Jenkins目录，保持宿主机清洁。如要删除数据重新安装，需要删除命名卷
> - `-e TZ=Asia/Shanghai`设置时区
> - 将宿主的/var/run/docker.sock文件挂载到容器内的同样位置，从而让容器内可以通过unix socket调用宿主的Docker引擎
> - 首次运行选择默认插件即可，初始密码在日志中可以找到
> - 邮件和SSH等详细设置参照官网：https://jenkins.io/

## Spring boot admin
使用`start.spring.io`创建最简单的spring boot admin项目，依赖选择ops下的`spring boot admin(server)`  
运行后在localhost:8080可以看到admin的界面

## Jenkinsfile
根目录下创建Jenkinsfile文件：
```jenkins
#!groovy
pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'maven:3.5.0-jdk-8-alpine'
                    args '-v mavenRepository:/root/.m2'
                }
            }
            steps {
                sh 'mvn -B -DskipTests clean package --settings settings.xml'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'maven:3.5.0-jdk-8-alpine'
                    args '-v mavenRepository:/root/.m2'
                }
            }
            steps {
                sh 'mvn test --settings settings.xml'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') {
            agent any
            steps {
                sh 'sh run.sh'
            }
        }
    }
    post {
        always {
            mail body: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - ${currentBuild.currentResult}: Check console output at ${env.BUILD_URL} to view the results.",
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - ${currentBuild.currentResult}!",
                    to: '353549444@qq.com'
        }
    }
}
```
> - 使用maven容器代理`Build`和`Test`这两个步骤，该容器生命只在stage中有效
> - 使用命名卷`mavenRepository`存储maven依赖，同一宿主机可共用
> - `Deliver`步骤不用代理，把前两步生成的jar部署到容器中
> - `post`步骤为发送结果邮件，需设置Jenkins管理邮箱和smtp

## 部署脚本run.sh
写的比较简单：
```bash
#!/bin/bash
# 停止admin容器
(docker stop admin && echo "stop success") || echo "stop error";

# 删除damin容器
(docker rm admin && echo "rm success") || echo "rm error";

# 删除原来镜像
(docker rmi admin && echo "rmi success") || echo "rmi error";

# 生成新的镜像
docker build -t admin .;

# 运行admin容器
docker run --name admin \
    -p 8899:8899 \
    -d \
    -e TZ=Asia/Shanghai \
    admin
```

## Dockerfile
```dockerfile
FROM openjdk:8-jdk-alpine as APP
VOLUME /tmp
COPY target/admin-1.0.jar app.jar
ENV JAVA_OPTS="-Xms512m -Xmx2048m"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]
```

## 参考链接
Jenkins持续集成maven项目：https://jenkins.io/doc/tutorials/build-a-java-app-with-maven
CentOS安装Docker：https://docs.docker.com/install/linux/docker-ce/centos