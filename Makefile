# registry prefix
IMAGE_TAG := quay.io/myorg/app:latest

.PHONY: linux arm macos windows image clean

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
	@echo "Building image for $$(go env GOHOSTOS)/$$(go env GOARCH)…"
	docker buildx build \
		--platform=$$(go env GOHOSTOS)/$$(go env GOARCH) \
		--load \
		-t $(IMAGE_TAG) \
		.

clean:
	@echo "Removing image $(IMAGE_TAG)…"
	docker rmi $(IMAGE_TAG) || true
