FROM golang:alpine3.13 as builder
LABEL maintainer="tommylike<tommylikehu@gmail.com>"
ARG GIT_COMMIT=375f66a
ARG VERSION="2.0.0-alpha.3"
WORKDIR /gotty
COPY . /gotty
RUN cd /gotty
RUN go get github.com/jteeuwen/go-bindata/...
RUN go get github.com/tools/godep
RUN go godep go build -ldflags "-X main.Version=$VERSION -X main.CommitID=$GIT_COMMIT"

FROM alpine:3.13
ARG user=app
ARG group=app
ARG home=/app
RUN addgroup -S ${group} && adduser -S ${user} -G ${group} -h ${home}

USER ${user}
WORKDIR ${home}
COPY --chown=${user} --from=builder /app/gotty .
ENTRYPOINT ["/app/gotty"]