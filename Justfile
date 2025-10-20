# Fail on warnings
export RUSTFLAGS := "-Dwarnings"

# Default (list of commands)
default:
    just -l

# Run fmt
fmt:
    @rustup component add rustfmt --toolchain nightly
    @cargo +nightly fmt --all -- --config imports_granularity=Crate

# Check fmt
fmt-check:
	@rustup component add rustfmt --toolchain nightly
	@cargo +nightly fmt --all -- --check --config imports_granularity=Crate || (echo "Formatting check failed. Please run 'just fmt' to fix formatting issues." && exit 1)

# Build (release)
build-release:
    cargo build --release

# Build (debug)
build-debug:
    cargo build

# Build (debug)
build: build-debug

# Run clippy
clippy:
    cargo clippy --all-features --all-targets -- -Dclippy::all

# Run lint checks (clippy and fmt-check)
lint: fmt-check clippy

# Run tests
test:
    cargo nextest run

# Clean
clean:
    cargo clean

# Coverage
cov:
    cargo llvm-cov nextest --open

# Run examples
examples:
    cargo run --example basic

# Run CI pipeline
ci:
    just lint
    just examples
    just test
    just build
