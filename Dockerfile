# build stage
FROM golang:1.17.3 as builder
WORKDIR /go/src/github.com/bratteng/imagepullsecret-patcher/

COPY go.mod .
COPY go.sum .

RUN go mod download
COPY cmd ./cmd/

RUN go build -o /go/bin/imagepullsecret-patcher ./...

# final stage
FROM gcr.io/distroless/base

COPY --from=builder /go/bin/imagepullsecret-patcher /

ENTRYPOINT ["/imagepullsecret-patcher"]
