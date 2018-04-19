# spring-boot-admin-jenkins-docker

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
