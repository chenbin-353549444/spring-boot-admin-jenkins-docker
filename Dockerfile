FROM openjdk:8-jdk-alpine as APP
VOLUME /tmp
COPY target/admin-1.0.jar app.jar
ENV JAVA_OPTS="-Xms512m -Xmx2048m"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]