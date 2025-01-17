export RUSTFLAGS := "-D warnings"
export RUSTDOCFLAGS := "-D warnings"

@_choose:
	just --choose --unsorted

# Perform all verifications (compile, test, lint, etc.)
verify: doc lint test

# Watch changes, and run `just verify` when source changes
watch:
	cargo watch -s 'just verify'

# Run all tests
test:
	cargo hack test --feature-powerset --exclude-features bevy-06,bevy-07,bevy-08,bevy-ecs-06,bevy-ecs-07,bevy-ecs-08,bevy-transform-06,bevy-transform-07,bevy-transform-08

# Static code analysis
lint:
	cargo fmt -- --check
	cargo clippy --all-features --all-targets

# Build the documentation
doc:
	cargo doc --all-features --no-deps

# Clean up compilation output
clean:
	rm -rf target
	rm -f Cargo.lock
	rm -rf node_modules

# Install cargo dev-tools used by other recipes (requires rustup to be already installed)
install-dev-tools:
	rustup install stable
	rustup override set stable
	cargo install cargo-hack cargo-watch

# Install a git hook to run tests before every commits
install-git-hooks:
	echo "#!/usr/bin/env sh" > .git/hooks/pre-commit
	echo "just verify" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
