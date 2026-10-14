# Smoke test: no behaviour exists yet, so this proves the toolchain works — the package is
# installed in the venv, importable, and type-checked under mypy strict.
import books_api


def test_package_imports() -> None:
    # Fixed: assert only that the package imports, so the test survives M1.02 replacing the placeholder.
    # was: assert callable(books_api.main)
    assert books_api.__name__ == "books_api"
