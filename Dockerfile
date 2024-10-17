FROM openjdk:21
EXPOSE 8087
ADD target/new-image.jar new-image.jar
ENTRYPOINT ["java", "-jar", "/new-image.jar"]