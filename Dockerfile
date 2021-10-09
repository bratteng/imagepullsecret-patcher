# build stage
FROM golang:1.17.2 as builder
WORKDIR /go/src/github.com/bratteng/imagepullsecret-patcher/

COPY go.mod .
COPY go.sum .

RUN go mod download
COPY cmd ./cmd/

RUN go build -o /go/bin/imagepullsecret-patcher ./...

# final stage
FROM scratch

COPY --from=builder /go/bin/imagepullsecret-patcher /

CMD ["/imagepullsecret-patcher"]
