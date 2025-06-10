FROM quay.io/projectquay/golang:1.20 AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# задаємо цільові платформи як build-args
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# компіляція бінарника
RUN CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    go test -c -o test_binary ./...

# Створюємо кінцевий образ тільки з тестовим бінарником
FROM scratch AS tester
COPY --from=builder /app/test_binary /test_binary
ENTRYPOINT ["/app"]
