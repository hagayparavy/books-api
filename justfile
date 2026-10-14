# https://just.systems

# First recipe = what bare `just` runs. `@` hides the command echo.
# List available recipes
default:
    @just --list

# One-step setup for a fresh clone: deps (incl. dev group) + git hooks.
# Install dependencies and git hooks
install:
    uv sync
    uv run pre-commit install

# Read-only on purpose: `--check` fails on unformatted code instead of rewriting it,
# so `just check` (and CI) never modifies files.
# Lint and verify formatting (no changes)
lint:
    uv run ruff check
    uv run ruff format --check

# The only recipe that writes files: autofix lint issues first, then format.
# Autofix lint issues and format code
format:
    uv run ruff check --fix
    uv run ruff format

# mypy reads `files` and `strict` from pyproject.toml, so no args here.
# Type-check with mypy (strict)
typecheck:
    uv run mypy

# Run the test suite
test:
    uv run pytest

# Dependencies run in order; `check` has no body of its own. This is what CI runs.
# Run all checks (lint, typecheck, test)
check: lint typecheck test
