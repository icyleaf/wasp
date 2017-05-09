CRYSTAL_BIN ?= $(shell which crystal)
PREFIX ?= /usr/local

build:
	$(CRYSTAL_BIN) build --release -o bin/wasp src/wasp.cr $(CRFLAGS)

clean:
	rm -rf bin
	mkdir bin