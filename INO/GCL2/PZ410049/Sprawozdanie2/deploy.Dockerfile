FROM java_builder

COPY --from=java_builder /jenkins-java/target/*.jar /jenkins-java/app.jar
WORKDIR /jenkins-java
RUN rm -rf mvnw mvnw.cmd pom.xml src target
CMD ["java", "-jar", "/jenkins-java/app.jar"]
