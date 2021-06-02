FROM java:8-jdk-alpine
MAINTAINER mayukh656
COPY ./target/bootcamp-0.0.1-SNAPSHOT.jar bootcamp-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "bootcamp-0.0.1-SNAPSHOT.jar"]
