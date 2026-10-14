# books-api

The backend of the Books Tracker: a REST API (FastAPI + PostgreSQL) that stores your books and reading
status, and looks up book metadata through the [`bookmeta`](https://pypi.org/project/bookmeta/) library.
The web app (`books-web`) and the Android app (`books-android`) are its clients; they integrate over HTTP
using the OpenAPI spec published with each release.

## Prerequisites

- [uv](https://docs.astral.sh/uv/) — Python package and project manager
- [just](https://just.systems/) — command runner
- git

You don't need to install Python yourself: uv downloads the version pinned in `.python-version`.

## Getting started

```sh
git clone git@github.com:hagayparavy/books-api.git
cd books-api
just install   # dependencies + git hooks
just test
```

## Commands

<!-- Mirrors `just --list`; update both together. -->
| Command | What it does |
|---|---|
| `just` | List available recipes |
| `just install` | Install dependencies and git hooks |
| `just lint` | Lint and verify formatting (no changes) |
| `just format` | Autofix lint issues and format code |
| `just typecheck` | Type-check with mypy (strict) |
| `just test` | Run the test suite |
| `just check` | Run all checks (lint, typecheck, test) — what CI runs |

## License

[MIT](LICENSE)
