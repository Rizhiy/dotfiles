#!/usr/bin/env python3
import fcntl
import importlib
import json
import os
import re
import signal
import subprocess
import sys
import threading
from datetime import datetime, timezone
from pathlib import Path

import gi
from brightness_schedule import (  # type: ignore[import-not-found]
    load_schedule,
    next_boundary,
    parse_number,
    scheduled_temperature,
)

gi.require_version("Gdk", "3.0")
gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
gi.require_version("GLibUnix", "2.0")
Gdk = importlib.import_module("gi.repository.Gdk")
GLib = importlib.import_module("gi.repository.GLib")
GLibUnix = importlib.import_module("gi.repository.GLibUnix")
Gtk = importlib.import_module("gi.repository.Gtk")
GtkLayerShell = importlib.import_module("gi.repository.GtkLayerShell")

STATE = (
    Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    / "brightness-widget.json"
)
CSS = Path(__file__).with_suffix(".css")
SCHEDULE = Path.home() / ".config/brightness-widget/schedule.conf"
RUNTIME = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp"))
PID = RUNTIME / f"brightness-widget-{os.getuid()}.pid"


def clamp(value, minimum, maximum):
    return max(minimum, min(maximum, value))


def ddc_buses(output):
    buses = []
    valid = False
    for line in output.splitlines():
        if line.startswith("Display "):
            valid = True
        elif line.startswith("Invalid display"):
            valid = False
        elif valid and (match := re.search(r"/dev/i2c-(\d+)", line)):
            buses.append(match.group(1))
    return buses


def load_state():
    try:
        return json.loads(STATE.read_text())
    except (OSError, ValueError):
        return {}


def save_state(monitor, gamma, temperature):
    STATE.parent.mkdir(parents=True, exist_ok=True)
    STATE.write_text(
        json.dumps(
            {
                "monitor": round(monitor),
                "gamma": round(gamma, 2),
                "temperature": round(temperature),
            }
        )
    )


def run(command, timeout=15):
    return subprocess.run(
        command, text=True, capture_output=True, timeout=timeout, check=False
    )


def detect_buses():
    try:
        return ddc_buses(run(["ddcutil", "detect", "--brief"], 20).stdout)
    except (OSError, subprocess.TimeoutExpired):
        return []


def read_monitor_brightness(bus, fallback):
    try:
        output = run(["ddcutil", "--bus", bus, "getvcp", "10"], 8).stdout
        match = re.search(r"current value\s*=\s*(\d+)", output)
        return int(match.group(1)) if match else fallback
    except (OSError, subprocess.TimeoutExpired):
        return fallback


class LatestWorker:
    def __init__(self, action):
        self.action = action
        self.pending = None
        self.condition = threading.Condition()
        threading.Thread(target=self._run, daemon=True).start()

    def submit(self, value):
        with self.condition:
            self.pending = value
            self.condition.notify()

    def _run(self):
        while True:
            with self.condition:
                while self.pending is None:
                    self.condition.wait()
                value, self.pending = self.pending, None
            self.action(value)


class Controller:
    def __init__(self):
        state = load_state()
        self.buses = detect_buses()
        fallback = clamp(parse_number(state.get("monitor", 40), int, STATE), 1, 100)
        self.monitor = (
            read_monitor_brightness(self.buses[0], fallback) if self.buses else fallback
        )
        self.gamma = clamp(
            parse_number(state.get("gamma", 0.6), float, STATE), 0.1, 1.0
        )
        self.temperature = clamp(
            parse_number(state.get("temperature", 6500), int, STATE), 1000, 10000
        )
        self.location = None
        self.schedule = []
        self.manual_until = None
        try:
            self.location, self.schedule = load_schedule(SCHEDULE)
            self.temperature = scheduled_temperature(
                self.schedule, self.location, datetime.now().astimezone()
            )
        except (OSError, ValueError) as error:
            print(f"brightness widget: {error}", file=sys.stderr)
        self.popups = []
        self.monitor_worker = LatestWorker(self._set_monitor)
        self.gamma_worker = LatestWorker(self._set_gamma)

    def set_monitor(self, value, source=None):
        self.monitor = clamp(parse_number(value, int, "monitor slider"), 1, 100)
        self._sync(source)
        self._save()
        if self.buses:
            self.monitor_worker.submit(self.monitor)

    def set_gamma(self, value, source=None):
        self.gamma = round(clamp(value, 0.1, 1.0), 2)
        self._sync(source)
        self._save()
        self._apply_gamma()

    def set_temperature(self, value, source=None):
        self.temperature = clamp(
            parse_number(value, int, "temperature slider"), 1000, 10000
        )
        if self.schedule:
            self.manual_until = next_boundary(
                self.schedule, self.location, datetime.now().astimezone()
            )
        self._sync(source)
        self._save()
        self._apply_gamma()

    def schedule_tick(self):
        if not self.schedule:
            return True
        now = datetime.now().astimezone()
        if self.manual_until and now < self.manual_until:
            return True
        self.manual_until = None
        temperature = scheduled_temperature(self.schedule, self.location, now)
        if temperature != self.temperature:
            self.temperature = temperature
            self._sync(None)
            self._save()
            self._apply_gamma()
        return True

    def _save(self):
        save_state(self.monitor, self.gamma, self.temperature)

    def _apply_gamma(self):
        self.gamma_worker.submit((self.gamma, self.temperature))
        return False

    def _sync(self, source):
        for popup in self.popups:
            if popup is not source:
                popup.sync()

    def _set_monitor(self, value):
        for bus in self.buses:
            try:
                run(
                    ["ddcutil", "--bus", bus, "setvcp", "10", str(value), "--noverify"],
                    15,
                )
            except (OSError, subprocess.TimeoutExpired):
                pass

    @staticmethod
    def _set_gamma(settings):
        brightness, temperature = settings
        try:
            run(
                [
                    "busctl",
                    "--user",
                    "set-property",
                    "rs.wl-gammarelay",
                    "/",
                    "rs.wl.gammarelay",
                    "Temperature",
                    "q",
                    str(temperature),
                ],
                5,
            )
            run(
                [
                    "busctl",
                    "--user",
                    "set-property",
                    "rs.wl-gammarelay",
                    "/",
                    "rs.wl.gammarelay",
                    "Brightness",
                    "d",
                    f"{brightness:.2f}",
                ],
                5,
            )
        except (OSError, subprocess.TimeoutExpired):
            pass


class Popup:
    def _make_window(self, monitor, top_margin):
        window = Gtk.Window(type=Gtk.WindowType.TOPLEVEL)
        window.set_name("brightness-widget")
        window.set_decorated(False)
        window.set_resizable(False)
        window.add_events(
            Gdk.EventMask.ENTER_NOTIFY_MASK
            | Gdk.EventMask.LEAVE_NOTIFY_MASK
            | Gdk.EventMask.POINTER_MOTION_MASK
            | Gdk.EventMask.SCROLL_MASK
        )
        window.connect("enter-notify-event", self._expand)
        window.connect("motion-notify-event", self._expand)
        window.connect("leave-notify-event", self._schedule_collapse)
        window.connect("scroll-event", self._scroll)
        GtkLayerShell.init_for_window(window)
        GtkLayerShell.set_layer(window, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_monitor(window, monitor)
        GtkLayerShell.set_anchor(window, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(window, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(window, GtkLayerShell.Edge.TOP, top_margin)
        GtkLayerShell.set_exclusive_zone(window, 0)
        GtkLayerShell.set_keyboard_mode(window, GtkLayerShell.KeyboardMode.NONE)
        return window

    def __init__(self, controller, monitor):
        self.controller = controller
        self.syncing = False
        self.collapse_timer = None
        self.smooth_scroll = 0.0

        self.controls_window = self._make_window(monitor, 0)
        self.controls = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.controls.set_name("brightness-controls")
        self.controls_window.add(self.controls)

        self.monitor_scale = self._row("Monitor", 1, 100, 1, self.controller.monitor)
        self.monitor_scale.connect("value-changed", self._monitor_changed)
        self.gamma_scale = self._row("Gamma", 10, 100, 1, self.controller.gamma * 100)
        self.gamma_scale.connect("value-changed", self._gamma_changed)
        self.temperature_scale = self._row(
            "Temp", 1000, 10000, 100, self.controller.temperature
        )
        self.temperature_scale.connect("value-changed", self._temperature_changed)

        self.sync()

    def _row(self, label, minimum, maximum, step, value):
        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        name = Gtk.Label(label=label)
        name.set_xalign(0)
        name.set_size_request(58, -1)
        scale = Gtk.Scale.new_with_range(
            Gtk.Orientation.HORIZONTAL, minimum, maximum, step
        )
        scale.set_value(value)
        scale.set_draw_value(True)
        scale.connect("button-release-event", self._schedule_collapse)
        scale.set_value_pos(Gtk.PositionType.RIGHT)
        scale.set_size_request(220, -1)
        row.pack_start(name, False, False, 0)
        row.pack_start(scale, True, True, 0)
        self.controls.pack_start(row, False, False, 0)
        return scale

    def sync(self):
        self.syncing = True
        self.monitor_scale.set_value(self.controller.monitor)
        self.gamma_scale.set_value(self.controller.gamma * 100)
        self.temperature_scale.set_value(self.controller.temperature)
        self.syncing = False

    def _monitor_changed(self, scale):
        if not self.syncing:
            self.controller.set_monitor(scale.get_value(), self)

    def _gamma_changed(self, scale):
        if not self.syncing:
            self.controller.set_gamma(scale.get_value() / 100, self)

    def _temperature_changed(self, scale):
        if not self.syncing:
            self.controller.set_temperature(scale.get_value(), self)

    def _expand(self, _widget=None, _event=None):
        if self.collapse_timer:
            GLib.source_remove(self.collapse_timer)
            self.collapse_timer = None
        return False

    def toggle(self):
        if self.controls_window.get_visible():
            self.controls_window.hide()
        else:
            self.controls_window.show_all()

    def _schedule_collapse(self, _widget=None, _event=None):
        if self.collapse_timer:
            GLib.source_remove(self.collapse_timer)
        self.collapse_timer = GLib.timeout_add(1000, self._collapse)
        return False

    def _collapse(self):
        pointer = Gdk.Display.get_default().get_default_seat().get_pointer()
        gdk_window = self.controls_window.get_window()
        if gdk_window is not None:
            child, _x, _y, buttons = gdk_window.get_device_position(pointer)
            if child is not None or buttons & Gdk.ModifierType.BUTTON1_MASK:
                return True
        self.controls_window.hide()
        self.collapse_timer = None
        return False

    def _scroll(self, _widget, event):
        delta = 0
        if event.direction == Gdk.ScrollDirection.UP:
            delta = 0.05
        elif event.direction == Gdk.ScrollDirection.DOWN:
            delta = -0.05
        elif event.direction == Gdk.ScrollDirection.SMOOTH:
            success, _delta_x, delta_y = event.get_scroll_deltas()
            if not success:
                return False
            self.smooth_scroll += delta_y
            if abs(self.smooth_scroll) < 0.1:
                return True
            delta = -0.05 if self.smooth_scroll > 0 else 0.05
            self.smooth_scroll = 0.0
        else:
            return False
        self.controller.set_gamma(self.controller.gamma + delta)
        return True


def self_test():
    sample = """Invalid display\n   I2C bus: /dev/i2c-3\nDisplay 1\n   I2C bus: /dev/i2c-4\nDisplay 2\n   I2C bus: /dev/i2c-5\n"""
    assert ddc_buses(sample) == ["4", "5"]
    assert clamp(2, 10, 100) == 10
    assert clamp(120, 10, 100) == 100
    location, entries = load_schedule(SCHEDULE)
    halfway = datetime(2026, 1, 1, 7, 30, tzinfo=timezone.utc)
    assert scheduled_temperature(entries, location, halfway) == 5250


def signal_daemon(signum):
    try:
        os.kill(parse_number(PID.read_text(), int, PID), signum)
    except (OSError, ValueError, ProcessLookupError):
        pass


def status():
    state = load_state()
    try:
        gamma = clamp(float(state.get("gamma", 0.6)), 0.1, 1.0)
    except (TypeError, ValueError):
        gamma = 0.6
    print(f"󰃠 {round(gamma * 100)}%")


def main():
    if "--self-test" in sys.argv:
        self_test()
        return
    if "--status" in sys.argv:
        status()
        return
    if "--toggle" in sys.argv:
        signal_daemon(signal.SIGUSR1)
        return
    if "--gamma-up" in sys.argv:
        signal_daemon(signal.SIGUSR2)
        return
    if "--gamma-down" in sys.argv:
        signal_daemon(signal.SIGHUP)
        return

    lock_path = (
        Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp"))
        / f"brightness-widget-{os.getuid()}.lock"
    )
    lock = lock_path.open("w")
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        return

    if CSS.exists():
        provider = Gtk.CssProvider()
        provider.load_from_path(str(CSS))
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

    PID.write_text(str(os.getpid()))
    controller = Controller()
    controller._save()
    display = Gdk.Display.get_default()
    for index in range(display.get_n_monitors()):
        popup = Popup(controller, display.get_monitor(index))
        controller.popups.append(popup)

    def toggle_popups():
        for popup in controller.popups:
            popup.toggle()
        return True

    def adjust_gamma(delta):
        controller.set_gamma(controller.gamma + delta)
        return True

    GLibUnix.signal_add(GLib.PRIORITY_DEFAULT, signal.SIGUSR1, toggle_popups)
    GLibUnix.signal_add(GLib.PRIORITY_DEFAULT, signal.SIGUSR2, adjust_gamma, 0.05)
    GLibUnix.signal_add(GLib.PRIORITY_DEFAULT, signal.SIGHUP, adjust_gamma, -0.05)
    controller._apply_gamma()
    GLib.timeout_add_seconds(2, controller._apply_gamma)
    GLib.timeout_add_seconds(30, controller.schedule_tick)
    Gtk.main()


if __name__ == "__main__":
    main()
