SHELL := bash
.ONESHELL:

VER=$(shell git describe --tags --always --dirty)
GO=$(shell which go)
GOGET=$(GO) get
GOINSTALL=$(GO) install
GOMOD=$(GO) mod
GOFMT=$(GO) fmt
GOBUILD=$(GO) build -trimpath -mod=readonly -ldflags "-X main.version=$(VER:v%=%) -s -w -buildid="

dir:
	@if [ ! -d bin ]; then mkdir -p bin; fi

mod:
	@$(GOMOD) download
	@$(GOINSTALL) github.com/google/go-licenses@latest

format:
	@$(GOFMT) ./...

build/linux/armv7: dir mod
	export CGO_ENABLED=0
	export GOOS=linux
	export GOARCH=arm
	export GOARM=7
	$(GOBUILD) -o bin/tbshasher-linux-$(VER:v%=%)-armv7 ./cmd/tbshasher

build/linux/arm64: dir mod
	export CGO_ENABLED=0
	export GOOS=linux
	export GOARCH=arm64
	$(GOBUILD) -o bin/tbshasher-linux-$(VER:v%=%)-arm64 ./cmd/tbshasher

build/linux/386: dir mod
	export CGO_ENABLED=0
	export GOOS=linux
	export GOARCH=386
	$(GOBUILD) -o bin/tbshasher-linux-$(VER:v%=%)-386 ./cmd/tbshasher

build/linux/amd64: dir mod
	export CGO_ENABLED=0
	export GOOS=linux
	export GOARCH=amd64
	$(GOBUILD) -o bin/tbshasher-linux-$(VER:v%=%)-amd64 ./cmd/tbshasher

build/linux: build/linux/armv7 build/linux/arm64 build/linux/386 build/linux/amd64

build/freebsd/armv7: dir mod
	export CGO_ENABLED=0
	export GOOS=freebsd
	export GOARCH=arm
	export GOARM=7
	$(GOBUILD) -o bin/tbshasher-freebsd-$(VER:v%=%)-armv7 ./cmd/tbshasher

build/freebsd/arm64: dir mod
	export CGO_ENABLED=0
	export GOOS=freebsd
	export GOARCH=arm64
	$(GOBUILD) -o bin/tbshasher-freebsd-$(VER:v%=%)-arm64 ./cmd/tbshasher

build/freebsd/386: dir mod
	export CGO_ENABLED=0
	export GOOS=freebsd
	export GOARCH=386
	$(GOBUILD) -o bin/tbshasher-freebsd-$(VER:v%=%)-386 ./cmd/tbshasher

build/freebsd/amd64: dir mod
	export CGO_ENABLED=0
	export GOOS=freebsd
	export GOARCH=amd64
	$(GOBUILD) -o bin/tbshasher-freebsd-$(VER:v%=%)-amd64 ./cmd/tbshasher

build/freebsd: build/freebsd/armv7 build/freebsd/arm64 build/freebsd/386 build/freebsd/amd64

build/openbsd/armv7: dir mod
	export CGO_ENABLED=0
	export GOOS=openbsd
	export GOARCH=arm
	export GOARM=7
	$(GOBUILD) -o bin/tbshasher-openbsd-$(VER:v%=%)-armv7 ./cmd/tbshasher

build/openbsd/arm64: dir mod
	export CGO_ENABLED=0
	export GOOS=openbsd
	export GOARCH=arm64
	$(GOBUILD) -o bin/tbshasher-openbsd-$(VER:v%=%)-arm64 ./cmd/tbshasher

build/openbsd/386: dir mod
	export CGO_ENABLED=0
	export GOOS=openbsd
	export GOARCH=386
	$(GOBUILD) -o bin/tbshasher-openbsd-$(VER:v%=%)-386 ./cmd/tbshasher

build/openbsd/amd64: dir mod
	export CGO_ENABLED=0
	export GOOS=openbsd
	export GOARCH=amd64
	$(GOBUILD) -o bin/tbshasher-openbsd-$(VER:v%=%)-amd64 ./cmd/tbshasher

build/openbsd: build/openbsd/armv7 build/openbsd/arm64 build/openbsd/386 build/openbsd/amd64

build/darwin/arm64: dir mod
	export CGO_ENABLED=0
	export GOOS=darwin
	export GOARCH=arm64
	$(GOBUILD) -o bin/tbshasher-darwin-$(VER:v%=%)-arm64 ./cmd/tbshasher

build/darwin/amd64: dir mod
	export CGO_ENABLED=0
	export GOOS=darwin
	export GOARCH=amd64
	$(GOBUILD) -o bin/tbshasher-darwin-$(VER:v%=%)-amd64 ./cmd/tbshasher

build/darwin: build/darwin/arm64 build/darwin/amd64

build/windows/386: dir mod
	export CGO_ENABLED=0
	export GOOS=windows
	export GOARCH=386
	$(GOBUILD) -o bin/tbshasher-windows-$(VER:v%=%)-386 ./cmd/tbshasher

build/windows/amd64: dir mod
	export CGO_ENABLED=0
	export GOOS=windows
	export GOARCH=amd64
	$(GOBUILD) -o bin/tbshasher-windows-$(VER:v%=%)-amd64 ./cmd/tbshasher

build/windows: build/windows/386 build/windows/amd64

build: build/linux build/freebsd build/openbsd build/darwin build/windows

license: dir
	cp NOTICE bin/NOTICE
	cp LICENSE bin/LICENSE
	go-licenses save ./cmd/tbshasher --ignore github.com/CHTJonas/tbshasher --save_path bin/licenses
	(cd bin/licenses && zip -r ../third-party-licenses.zip . -i **/LICENSE **/NOTICE **/COPYING)
	rm -rf bin/licenses

clean:
	@rm -rf bin

all: format build license
