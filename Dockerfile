
# Stage 1. Build Java Application
FROM docker.io/maven:3.8-openjdk-11 as build
COPY . /tmp/src
WORKDIR /tmp/src
RUN mvn clean package

# Stage 2. Build Liberty Custom Image
FROM docker.io/ibmcom/websphere-liberty:22.0.0.3-full-java11-openj9-ubi

ARG VERSION=1.0
ARG REVISION=SNAPSHOT

LABEL \
  org.opencontainers.image.authors="Takakiyo" \
  org.opencontainers.image.vendor="IBM Japan, Automation Software" \
  org.opencontainers.image.url="local" \
  org.opencontainers.image.source="https://github.com/takakiyo/liberty-watson" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$REVISION" \
  vendor="IBM Japan" \
# tag::name[]
  name="liberty-watson" \
# end::name[]
  version="$VERSION-$REVISION" \
# tag::summary[]
  summary="The sample of Containerizing Liberty" \
  description="This image contains the Watson demo app with the Open Liberty runtime."
# end::summary[]

COPY --chown=1001:0 src/main/liberty/config /config/

# tag::copy-war[]
COPY --chown=1001:0 --from=build /tmp/src/target/liberty-watson.war /config/apps
# end::copy-war[]

RUN configure.sh
