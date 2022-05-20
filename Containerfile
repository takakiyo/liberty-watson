FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi

ARG VERSION=1.0
ARG REVISION=SNAPSHOT

LABEL \
  org.opencontainers.image.authors="Takakiyo" \
  org.opencontainers.image.vendor="c" \
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
COPY --chown=1001:0 target/liberty-watson.war /config/apps
# end::copy-war[]

RUN configure.sh
