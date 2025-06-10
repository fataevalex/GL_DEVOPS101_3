# registry prefix
IMAGE_TAG := quay.io/myorg/app:latest

.PHONY: linux arm macos windows image clean

linux:
	GOOS=linux   GOARCH=amd64 go build -o bin/app_linux_amd64   ./...

arm:
	GOOS=linux   GOARCH=arm64 go build -o bin/app_linux_arm64   ./...

macos:
	GOOS=darwin  GOARCH=amd64 go build -o bin/app_darwin_amd64  ./...

windows:
	GOOS=windows GOARCH=amd64 go build -o bin/app_windows_amd64.exe ./...

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
