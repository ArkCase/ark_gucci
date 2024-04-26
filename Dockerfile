ARG VER="1.7.0"
ARG SRC="https://github.com/ArkCase/gucci.git"
ARG SRCPATH="/build/gucci"

ARG BUILDER_IMAGE="golang"
ARG BUILDER_VER="1.22-alpine3.19"
ARG BUILDER_IMG="${BUILDER_IMAGE}:${BUILDER_VER}"

FROM "${BUILDER_IMG}" AS builder

ARG VER
ARG SRC
ARG SRCPATH

ARG VER="1.7.0"
ARG SRC="https://github.com/ArkCase/gucci.git"
ARG SRCPATH="/build/gucci"

RUN apk --no-cache add git
RUN mkdir -p "${SRCPATH}" && \
    git clone "${SRC}" "${SRCPATH}" && \
    cd "${SRCPATH}" && \
    git checkout "${VER}" && \
    GO111MODULE=on \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -ldflags "-X 'main.AppVersion=v${VER}' -extldflags '-static'" -o /gucci

FROM scratch 

ARG VER

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Gucci" \
      VERSION="${VER}"

COPY --from=builder /gucci /gucci

ENTRYPOINT [ "/gucci" ]
