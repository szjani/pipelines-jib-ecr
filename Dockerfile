FROM golang:1.12.7-alpine3.10 AS ecr-credential-helper
RUN apk --no-cache add git gcc g++ musl-dev
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/...
WORKDIR /go/src/github.com/awslabs/amazon-ecr-credential-helper
RUN git checkout "v0.3.1"
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
RUN go build -ldflags "-s -w" -installsuffix cgo -a -o /ecr-login \
    ./ecr-login/cli/docker-credential-ecr-login

FROM maven:3.6.1-jdk-11
COPY --from=ecr-credential-helper /ecr-login /usr/bin/docker-credential-ecr-login
