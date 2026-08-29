import importlib
import re
from dataclasses import dataclass
from datetime import datetime, time, timedelta


@dataclass(frozen=True)
class Entry:
    when: str
    temperature: int
    transition: timedelta


def parse_number(value, kind, source):
    try:
        return kind(value)
    except (TypeError, ValueError) as error:
        raise ValueError(f"invalid number in {source}: {value}") from error


def parse_duration(value):
    match = re.fullmatch(r"(\d{1,2}):(\d{2})", value)
    if not match:
        raise ValueError(f"invalid duration: {value}")
    hours = parse_number(match.group(1), int, value)
    minutes = parse_number(match.group(2), int, value)
    if minutes > 59:
        raise ValueError(f"invalid duration: {value}")
    return timedelta(hours=hours, minutes=minutes)


def load_schedule(path):
    location = None
    entries = []
    for number, raw in enumerate(path.read_text().splitlines(), 1):
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        parts = line.split()
        source = f"{path}:{number}"
        if parts[0].lower() == "location" and len(parts) == 3:
            location = (
                parse_number(parts[1], float, source),
                parse_number(parts[2], float, source),
            )
            continue
        if len(parts) != 3:
            raise ValueError(f"{source}: expected <time> <temperature> <transition>")
        temperature = parse_number(parts[1], int, source)
        if not 1000 <= temperature <= 10000:
            raise ValueError(f"{path}:{number}: temperature must be 1000–10000K")
        entries.append(Entry(parts[0].upper(), temperature, parse_duration(parts[2])))
    if not entries:
        raise ValueError(f"{path}: schedule is empty")
    return location, entries


def _solar_time(day, event, location, timezone):
    if location is None:
        raise ValueError(
            "SUNRISE/SUNSET requires a 'location <latitude> <longitude>' line"
        )
    try:
        observer = importlib.import_module("astral").Observer(*location)
        sun = importlib.import_module("astral.sun").sun
    except (ImportError, AttributeError) as error:
        raise ValueError(
            "SUNRISE/SUNSET requires the Arch package python-astral"
        ) from error
    return sun(observer, date=day, tzinfo=timezone)[event]


def resolve_when(value, day, location, timezone):
    match = re.fullmatch(r"(SUNRISE|SUNSET)(?:([+-])(\d{1,2}):(\d{2}))?", value)
    if match:
        result = _solar_time(day, match.group(1).lower(), location, timezone)
        if match.group(2):
            hours = parse_number(match.group(3), int, value)
            minutes = parse_number(match.group(4), int, value)
            if minutes > 59:
                raise ValueError(f"invalid solar offset: {value}")
            offset = timedelta(hours=hours, minutes=minutes)
            result += offset if match.group(2) == "+" else -offset
        return result
    parsed = time.fromisoformat(value)
    return datetime.combine(day, parsed, timezone)


def resolved_events(entries, location, now):
    events = []
    for day_offset in (-1, 0, 1):
        day = now.date() + timedelta(days=day_offset)
        events.extend(
            (resolve_when(entry.when, day, location, now.tzinfo), entry)
            for entry in entries
        )
    return sorted(events, key=lambda item: item[0])


def scheduled_temperature(entries, location, now):
    events = resolved_events(entries, location, now)
    index = max(index for index, (when, _entry) in enumerate(events) if when <= now)
    started, current = events[index]
    previous = events[index - 1][1]
    if current.transition.total_seconds() <= 0 or now >= started + current.transition:
        return current.temperature
    progress = (now - started) / current.transition
    return round(
        previous.temperature + (current.temperature - previous.temperature) * progress
    )


def next_boundary(entries, location, now):
    return next(
        when for when, _entry in resolved_events(entries, location, now) if when > now
    )
