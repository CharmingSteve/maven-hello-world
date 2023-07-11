# First stage: Maven builder
FROM maven:3.8.2-openjdk-11-slim AS builder
# Create a group and user
RUN groupadd -r nonroot && useradd -r -g nonroot nonroot
# Switch to nonroot user
USER nonroot
WORKDIR /app
COPY --chown=nonroot:nonroot ./myapp /app
ARG revision
RUN echo $revision
RUN mvn -B package -Drevision=$revision

# Second stage: Java runner
FROM adoptopenjdk:11-jre-hotspot
ARG revision
ENV VERSION=$revision
RUN echo "VERSION set to: $VERSION"
RUN groupadd -r nonroot && useradd -r -g nonroot nonroot
USER nonroot
COPY --from=builder /app/target/myapp-*.jar /my-app.jar
CMD ["sh", "-c", "java -Dversion=$VERSION -jar /my-app.jar"]
