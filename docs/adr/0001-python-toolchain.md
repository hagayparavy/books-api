# ADR-0001: Python toolchain

- Status: Accepted
- Date: 2026-10-08
- Owners: hagay paravy

## Context

`books-api` is a new Python service, built by a developer coming from TypeScript, where npm scripts,
`tsc --strict`, ESLint/Prettier and husky are the defaults. The Python ecosystem has several competing
tools for each of those jobs, and the choice has to be made before the first line of code because some
choices (project layout, strict typing) are expensive to retrofit. Goals: strict from day one, fast
feedback, one obvious command per task, and the same checks locally and in CI.

## Decision

| Concern | Choice |
|---|---|
| Package / project manager | **uv**: virtualenv, lockfile (`uv.lock`), and Python installation in one tool |
| Project layout | **src layout** (`src/books_api/`), tests in `tests/` |
| Python version | **3.14**, pinned in `.python-version`, `requires-python = ">=3.14"` |
| Type checking | **mypy** with `strict = true`, over `src` and `tests` |
| Lint + format | **Ruff**: defaults plus `B, UP, I, SIM, N, S`; `S101` (assert) ignored in `tests/` |
| Git hooks | **pre-commit**: hygiene hooks, ruff check `--fix`, ruff format, local mypy hook |
| Command runner | **just**: `install`, `lint`, `format`, `typecheck`, `test`, `check` |
| Commit messages | **Conventional Commits** |
| License | **MIT** (SPDX `license = "MIT"` in `pyproject.toml`) |

All tool configuration lives in `pyproject.toml`; no separate dotfiles per tool.

## Alternatives Considered

1. **Poetry / pip + pip-tools** instead of uv: slower, and need a separate tool (pyenv) to install Python.
   uv covers all of it and is where the ecosystem is moving.
2. **Flat layout** (`books_api/` at the root) instead of src: tests could import the source folder directly
   and pass even when packaging is broken. src layout forces tests to use the installed package.
3. **Python 3.15** instead of 3.14: just released, so some dependencies may not ship wheels yet.
   3.14 is stable; bumping later is a small, deliberate PR.
4. **pyright** instead of mypy: faster and stricter by default, but mypy is the reference implementation
   and what most Python docs and libraries assume. Either would work.
5. **Black + isort + flake8** instead of Ruff: three tools and three configs for what Ruff does in one,
   at a fraction of the speed.
6. **make or a bash script** instead of just: make carries file-target semantics and tab pitfalls; a script
   means hand-writing argument dispatch, help text and "run A then B". just gives `just --list` and recipe
   dependencies for free, at the cost of one binary.

## Consequences

### Positive

- One fast tool (uv) handles Python install, venv, and locking; a fresh clone is `just install`.
- Packaging mistakes surface in tests thanks to src layout.
- Type errors are caught from the first commit; there is no untyped code to retrofit later.
- `just check` is the single entry point used locally, by `/lesson-review`, and by CI (M1.04).
- Commits are checked locally in about one second.

### Negative

- Strict typing slows down early prototyping; third-party libraries without type hints need stubs or
  targeted ignores.
- `just` is an extra prerequisite that every contributor must install.
- Ruff runs in two places (the pre-commit mirror hook and `uv.lock`), so its versions can drift.

## Implementation Notes

- **Deviation: gitleaks is disabled in pre-commit.** The default `gitleaks` hook compiles gitleaks from source
  with Go, and that build hung. Secrets are currently guarded only by GitHub secret scanning with push
  protection, which blocks a secret at push time and only for formats GitHub recognises. To restore it:
  install the release binary and use the `gitleaks-system` hook id.
- **Ruff version pairing:** after `pre-commit autoupdate` bumps ruff's hook `rev`, run
  `uv lock --upgrade-package ruff` so local, hook, and CI all use the same version.
- **Python 3.15 bump:** planned once the dependencies ship 3.15 wheels; record it as a new ADR that
  supersedes the version line of this one.
