

.PHONY: test
test: build
	cabal test

.PHONY: build
build: configure
	cabal build

.PHONY: configure
configure:
	cabal configure --enable-tests