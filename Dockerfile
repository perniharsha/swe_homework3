FROM openjdk:21-jdk-slim
ADD target/survey0.1-0.0.1-SNAPSHOT.jar survey.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/survey.jar"]