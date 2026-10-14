# Added: smoke test (M1.01 task 9). No behaviour exists yet, so it proves the toolchain works:
# the package is installed in the venv, importable, and type-checked under mypy strict.
import books_api


# Added: `-> None` is required — mypy strict rejects unannotated functions, tests included
def test_package_imports_and_exposes_main() -> None:
    # Added: plain `assert` is idiomatic pytest (it rewrites asserts to show both sides on failure);
    # Ruff's S101 is ignored for tests/ in pyproject.toml
    assert callable(books_api.main)
