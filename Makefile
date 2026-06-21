# Dotfiles maintenance. Treats the shell config as software.
# Run `make` for the target list. `make test` is what CI runs.

SHELL := bash

ZSH_FILES := zsh/.zshrc zsh/.zprofile $(wildcard zsh/conf.d/*.zsh)
SH_FILES  := setup.sh $(wildcard scripts/*.sh)

SECRET_RE := (AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[0-9A-Za-z-]{8,}|gh[pousr]_[0-9A-Za-z]{30,})

.DEFAULT_GOAL := help
.PHONY: help lint fmt test syntax shellcheck secrets

help: ## Show available targets
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN{FS=":.*?## "}{printf "  %-12s %s\n", $$1, $$2}'

lint: syntax shellcheck ## Lint everything (zsh -n + shellcheck)

syntax: ## Parse-check every zsh module
	@for f in $(ZSH_FILES); do zsh -n "$$f" && echo "  ok  $$f"; done

shellcheck: ## shellcheck the bash/sh scripts (warning severity and up)
	@command -v shellcheck >/dev/null || { echo "shellcheck missing (brew install shellcheck)"; exit 1; }
	@shellcheck --severity=warning $(SH_FILES) && echo "  shellcheck clean"

fmt: ## Format the bash/sh scripts with shfmt
	@command -v shfmt >/dev/null || { echo "shfmt missing (brew install shfmt)"; exit 1; }
	@shfmt -w -i 2 -ci $(SH_FILES) && echo "  formatted"

secrets: ## Fail if obvious secrets are committed
	@if git grep -nIE '$(SECRET_RE)' -- ':!Makefile' ':!.github' >/dev/null 2>&1; then \
		echo "potential secret found:"; \
		git grep -nIE '$(SECRET_RE)' -- ':!Makefile' ':!.github'; \
		exit 1; \
	else echo "  no secrets detected"; fi

test: syntax secrets ## CI checks: zsh syntax + secret scan
	@echo "all tests passed"
