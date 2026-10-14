# https://just.systems

# Fixed: bare `just` now lists the recipes instead of a placeholder. `@` hides the command echo.
# was:
#   default:
#       echo 'Hello, world!'
# List available recipes
default:
    @just --list

# Added: one-step setup for a fresh clone — deps (incl. dev group) + git hooks
# Install dependencies and git hooks
install:
    uv sync
    uv run pre-commit install

# Added: read-only checks. `--check` makes ruff format fail on unformatted code instead of rewriting it,
# so `just check` (and CI) never modifies files.
# Lint and verify formatting (no changes)
lint:
    uv run ruff check
    uv run ruff format --check

# Added: the only recipe that writes files — autofix lint issues first, then format
# Autofix lint issues and format code
format:
    uv run ruff check --fix
    uv run ruff format

# Added: mypy reads `files` and `strict` from pyproject.toml, so no args here
# Type-check with mypy (strict)
typecheck:
    uv run mypy

# Added: exits with code 5 ("no tests collected") until task 9 adds the smoke test
# Run the test suite
test:
    uv run pytest

# Added: dependencies run in order; `check` has no body of its own. This is what CI runs.
# Run all checks (lint, typecheck, test)
check: lint typecheck test
