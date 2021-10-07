# build stage
FROM golang:1.17.1 as builder

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY config_helper.go .
COPY main.go .
COPY secret.go .
COPY service_account.go .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/imagepullsecret-patcher

# final stage
FROM scratch

COPY --from=builder /go/bin/imagepullsecret-patcher /

CMD ["/imagepullsecret-patcher"]
