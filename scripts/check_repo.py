#!/usr/bin/env python3
"""Lightweight repository checks for the wrapper RTL tree."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FILELIST = ROOT / "filelist.f"


def iter_filelist_paths() -> list[tuple[int, str]]:
    paths: list[tuple[int, str]] = []
    for lineno, raw in enumerate(FILELIST.read_text().splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#") or line.startswith("+"):
            continue
        paths.append((lineno, line))
    return paths


def check_filelist() -> list[str]:
    errors: list[str] = []
    for lineno, entry in iter_filelist_paths():
        if Path(entry).is_absolute():
            errors.append(f"filelist.f:{lineno}: absolute path is not portable: {entry}")
        if not (ROOT / entry).exists():
            errors.append(f"filelist.f:{lineno}: listed source does not exist: {entry}")
    return errors


def check_required_files() -> list[str]:
    required = [
        "README.md",
        "Makefile",
        "boot.mem",
        "rtl/wrapper_top.sv",
        "tb/wrapper_smoke_tb.sv",
        "rtl/prim/prim_assert_dummy_macros.svh",
        "rtl/prim/prim_assert_standard_macros.svh",
        "rtl/prim/prim_assert_yosys_macros.svh",
        "rtl/prim/prim_assert_sec_cm.svh",
    ]
    return [f"missing required file: {path}" for path in required if not (ROOT / path).exists()]


def strip_sv_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    text = re.sub(r"//.*", "", text)
    return text


def modules_in(path: Path) -> list[str]:
    text = strip_sv_comments(path.read_text(errors="ignore"))
    return re.findall(r"(?m)^\s*module\s+([A-Za-z_][A-Za-z0-9_$]*)", text)


def check_duplicate_compiled_modules() -> list[str]:
    errors: list[str] = []
    seen: dict[str, str] = {}
    for _, entry in iter_filelist_paths():
        path = ROOT / entry
        if path.suffix not in {".sv", ".v"}:
            continue
        for module in modules_in(path):
            prev = seen.get(module)
            if prev is not None:
                errors.append(f"module {module} appears in both {prev} and {entry}")
            else:
                seen[module] = entry
    return errors


def main() -> int:
    errors = []
    errors.extend(check_filelist())
    errors.extend(check_required_files())
    errors.extend(check_duplicate_compiled_modules())

    if errors:
        print("Repository checks failed:")
        for error in errors:
            print(f"  - {error}")
        return 1

    print("Repository checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
