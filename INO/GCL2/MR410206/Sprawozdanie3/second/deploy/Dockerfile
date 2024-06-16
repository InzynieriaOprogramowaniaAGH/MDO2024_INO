FROM openjdk:latest

COPY --from=build /spring-petclinic/target/*.jar /my.jar

ENTRYPOINT ["java", "-jar", "/myerror.jar"]

EXPOSE 8080
