# First stage: Maven builder
FROM maven:3.8.2-openjdk-11-slim AS builder
WORKDIR /app
COPY ./myapp /app
ARG revision=1.0.0
RUN mvn -B package -Drevision=$revision

# Second stage: Java runner
FROM adoptopenjdk:11-jre-hotspot
COPY --from=builder /app/target/my-app-*.jar /my-app.jar
EXPOSE 8080
CMD ["java", "-jar", "/my-app.jar"]


# docker build -t charmingsteve/maven-hello-world:$new_version --build-arg revision=$new_version .
