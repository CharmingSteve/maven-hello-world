# First stage: Maven builder
FROM maven:3.8.2-openjdk-11-slim AS builder
WORKDIR /app
COPY ./myapp /app
ARG revision
RUN mvn -B package -Drevision=$revision

# Second stage: Java runner
FROM adoptopenjdk:11-jre-hotspot
COPY --from=builder /app/target/myapp-*.jar /my-app.jar
EXPOSE 8080
CMD /bin/sh -c "VERSION=$(echo /my-app.jar | sed -r 's/.*myapp-(.+)\.jar/\1/') java -jar /my-app.jar"
