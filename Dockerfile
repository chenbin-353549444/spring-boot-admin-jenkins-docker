FROM maven:3.5.0-jdk-8-alpine as BUILD
WORKDIR /usr/src/app
COPY pom.xml /usr/src/app
RUN mvn -B -e -C -T 1C org.apache.maven.plugins:maven-dependency-plugin:3.0.2:go-offline
COPY . /usr/src/app
RUN mvn -B -e -o -T 1C verify

FROM openjdk:8-jdk-alpine as APP
VOLUME /tmp
COPY --from=BUILD /usr/src/app/target/admin-1.0.jar app.jar
ENV JAVA_OPTS="-Xms512m -Xmx2048m"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]