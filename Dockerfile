# First stage: Maven builder
FROM maven:3.8.2-openjdk-11-slim AS builder
WORKDIR /app
COPY ./myapp /app
ARG revision
RUN echo $revision
RUN mvn -B package -Drevision=$revision
# Create a group and user
RUN groupadd -r nonroot && useradd -r -g nonroot -u 1000 nonroot
USER nonroot
COPY --from=builder /app/target/myapp-*.jar /my-app.jar
CMD ["sh", "-c", "java -Dversion=$VERSION -jar /my-app.jar"]

# Second stage: Java runner
FROM adoptopenjdk:11-jre-hotspot
ARG revision
ENV VERSION=$revision
RUN echo "VERSION set to: $VERSION"
# Create a group and user
RUN groupadd -r nonroot && useradd -r -g nonroot -u 1000 nonroot
USER 1000
COPY --from=builder /app/target/myapp-*.jar /my-app.jar
CMD ["sh", "-c", "java -Dversion=$VERSION -jar /my-app.jar"]
