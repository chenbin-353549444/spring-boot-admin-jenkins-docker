FROM maven:3.5.0-jdk-8-alpine as BUILD
COPY settings.xml /usr/share/maven/ref/
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN mvn clean package

FROM openjdk:8-jdk-alpine as APP
VOLUME /tmp
COPY --from=BUILD /usr/src/app/target/admin-1.0.jar app.jar
ENV JAVA_OPTS="-Xms512m -Xmx2048m"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]