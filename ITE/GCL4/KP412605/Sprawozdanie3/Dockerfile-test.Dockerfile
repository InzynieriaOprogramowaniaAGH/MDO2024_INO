FROM spring-builder:latest

RUN ./gradlew build -x test