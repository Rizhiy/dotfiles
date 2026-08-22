#!/usr/bin/env python3
"""Update Herdr's display metadata from an agent user-message hook."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time

MAX_PROMPT_CHARS = 8_000
MAX_TITLE_CHARS = 72
MAX_TITLE_WORDS = 10
GENERIC_FOLLOWUPS = {
    "continue",
    "do it",
    "go ahead",
    "okay",
    "ok",
    "same",
    "thanks",
    "thank you",
    "yes",
}


def read_input() -> dict:
    try:
        value = json.load(sys.stdin)
        return value if isinstance(value, dict) else {}
    except (json.JSONDecodeError, OSError):
        return {}


def clean_line(text: str) -> str:
    # Titles are always a single printable line. Code blocks are context, not titles.
    text = re.sub(r"```.*?```", " ", text, flags=re.DOTALL)
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    line = lines[0] if lines else ""
    line = re.sub(r"^#{1,6}\s+", "", line)
    line = re.sub(r"^[-*+]\s+", "", line)
    line = re.sub(
        r"^(?:please\s+|can you\s+|could you\s+|would you\s+|i want you to\s+)",
        "",
        line,
        flags=re.IGNORECASE,
    )
    line = re.sub(r"\s+", " ", line).strip(" `\t\r\n")
    return line


def title_for(prompt: str, previous: str | None) -> str:
    line = clean_line(prompt[:MAX_PROMPT_CHARS])
    if not line:
        return previous or "New session"

    normalized = line.casefold().rstrip(".!?")
    if normalized in GENERIC_FOLLOWUPS and previous:
        return previous

    words = line.split()
    if len(words) > MAX_TITLE_WORDS:
        line = " ".join(words[:MAX_TITLE_WORDS]).rstrip(".,:;-") + "…"
    if len(line) > MAX_TITLE_CHARS:
        line = line[: MAX_TITLE_CHARS - 1].rstrip() + "…"
    return line or previous or "New session"


def compact_cwd(value: str) -> str:
    try:
        cwd = str(Path(value).expanduser().resolve())
    except (OSError, RuntimeError):
        cwd = value
    home = str(Path.home())
    if cwd == home:
        return "~"
    if cwd.startswith(home + os.sep):
        return "~" + cwd[len(home) :]
    return cwd


def state_path(session_id: str) -> Path:
    runtime = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp"))
    digest = hashlib.sha256(session_id.encode()).hexdigest()[:24]
    directory = runtime / f"herdr-agent-sessions-{os.getuid()}"
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    return directory / f"{digest}.json"


def previous_title(path: Path) -> str | None:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
        title = value.get("title")
        return title if isinstance(title, str) and title else None
    except (OSError, json.JSONDecodeError):
        return None


def main() -> int:
    data = read_input()
    pane_id = os.environ.get("HERDR_PANE_ID")
    if os.environ.get("HERDR_ENV") != "1" or not pane_id:
        return 0

    prompt = data.get("prompt", data.get("text", ""))
    if not isinstance(prompt, str) or not prompt.strip():
        return 0

    cwd_value = data.get("cwd") or os.getcwd()
    cwd = compact_cwd(cwd_value if isinstance(cwd_value, str) else os.getcwd())
    session_value = data.get("session_id") or data.get("sessionId") or pane_id
    session_id = str(session_value)
    path = state_path(session_id)
    title = title_for(prompt, previous_title(path))
    path.write_text(
        json.dumps({"title": title, "cwd": cwd, "updated_at": time.time()}),
        encoding="utf-8",
    )

    herdr = os.environ.get("HERDR_BIN_PATH") or "herdr"
    command = [
        herdr,
        "pane",
        "report-metadata",
        pane_id,
        "--source",
        "user:session-context",
        "--title",
        title,
        "--token",
        f"session_title={title}",
        "--token",
        f"cwd={cwd}",
        "--seq",
        str(time.time_ns()),
    ]
    try:
        subprocess.run(
            command,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=2,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired):
        pass
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
