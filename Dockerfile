# First stage: Maven builder
FROM maven:3.8.2-openjdk-11-slim AS builder
WORKDIR /app
COPY ./myapp /app
ARG revision
RUN mvn -B package -Drevision=$revision

# Second stage: Java runner
FROM adoptopenjdk:11-jre-hotspot
ARG JAR_FILE=/app/target/myapp-*.jar
COPY --from=builder $JAR_FILE /my-app.jar
# Extract the version number from the JAR file name
ARG VERSION=$(echo $JAR_FILE | sed -r 's/.*myapp-(.+)\.jar/\1/')
# Set the VERSION environment variable
ENV VERSION=$VERSION
EXPOSE 8080
CMD ["java", "-jar", "/my-app.jar"]
