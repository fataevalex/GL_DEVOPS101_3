# registry prefix
IMAGE_TAG := quay.io/myorg/app:latest
HOSTOS   := $(shell uname -s | tr '[:upper:]' '[:lower:]' | sed -e 's/darwin/macos/')
HOSTARCH := $(shell uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')



.PHONY: linux_x86 linux_arm macos_x86 macos_arm win_x86 image clean

linux_x86:
	GOOS=linux   GOARCH=amd64 go build -o  app/myapp main.go

linux_arm:
	GOOS=linux   GOARCH=arm64 go build -o  app/myapp main.go

macos_x86:
	GOOS=darwin  GOARCH=amd64 go build -o  app/myapp main.go

macos_arm:
	GOOS=darwin  GOARCH=arm64 go build -o  app/myapp main.go

win_x86:
	GOOS=windows GOARCH=amd64 go build -o  app/myapp main.go

# build image
image:
	@echo "Building image for $(HOSTOS)/$(HOSTARCH)…"
	docker buildx build \
		--platform=$(HOSTOS)/$(HOSTARCH) \
		--load \
		-t $(IMAGE_TAG) \
		.

clean:
	@echo "Removing image $(IMAGE_TAG)…"
	docker rmi $(IMAGE_TAG) || true
