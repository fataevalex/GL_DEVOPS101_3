FROM quay.io/projectquay/golang:1.20 AS builder

WORKDIR ./...
COPY . .

# задаємо цільові платформи як build-args
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# компіляція бінарника
RUN CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    go build -o  myapp main.go
RUN pwd && ls
# Створюємо кінцевий образ тільки з тестовим бінарником
FROM scratch AS tester
COPY --from=builder /go/.../myapp /myapp
ENTRYPOINT ["/myapp"]
