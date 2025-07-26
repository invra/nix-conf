ARCH := $(shell uname -m)
ifeq ($(ARCH),x86_64)
    RUSTUP_URL := https://static.rust-lang.org/rustup/dist/x86_64-apple-darwin/rustup-init
endif
ifeq ($(ARCH),arm64)
    RUSTUP_URL := https://static.rust-lang.org/rustup/dist/aarch64-apple-darwin/rustup-init
endif

RUSTUP_BIN := .bootstrap/rustup-init
RUSTUP_HOME := $(CURDIR)/.bootstrap/rustup
CARGO_HOME := $(CURDIR)/.bootstrap/cargo

bootstrap: $(RUSTUP_BIN)
	RUSTUP_HOME=$(RUSTUP_HOME) \
	CARGO_HOME=$(CARGO_HOME) \
	RUSTUP_INIT_SKIP_PATH_CHECK=yes \
	$(RUSTUP_BIN) -y --no-modify-path --profile minimal
	echo Do not follow above tasks. This is meant to be a disposable environment.

.bootstrap/rustup-init:
	mkdir -p .bootstrap
	curl -fsSL $(RUSTUP_URL) -o $(RUSTUP_BIN)
	chmod +x $(RUSTUP_BIN)
