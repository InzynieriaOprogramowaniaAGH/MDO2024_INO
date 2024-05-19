FROM openjdk:latest

COPY --from=app-bld /spring-petclinic/target/*.jar /app/app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]

EXPOSE 8080
