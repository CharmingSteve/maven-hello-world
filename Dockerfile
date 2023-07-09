# First stage: Maven builder
FROM maven:3.8.2-openjdk-11-slim AS builder
WORKDIR /app
COPY ./myapp /app
ARG revision
RUN mvn -B package -Drevision=$revision

# Second stage: Java runner
FROM adoptopenjdk:11-jre-hotspot
ARG revision
RUN echo $revision
ENV VERSION=$revision
COPY --from=builder /app/target/myapp-*.jar /my-app.jar
CMD ["java", "-jar", "/my-app.jar"]
