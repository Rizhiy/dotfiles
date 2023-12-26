#!/home/rizhiy/miniconda3/bin/python
import os
import sys
from pathlib import Path

from Xlib import display
from Xlib.ext import randr

d = display.Display()
res = randr.get_screen_resources(d.screen().root)

results = []
for output in res.outputs:
    params = d.xrandr_get_output_info(output, res.config_timestamp)
    if not params.crtc:
        continue
    results.append(params.name)
results = sorted(results)
if len(results) >= 2:
    left, right, *other_monitors = results
else:
    left, right = results[0], results[0]
    other_monitors = []


monitors_path = Path(__file__).absolute().parents[1] / ".local" / "share" / "monitors"
with monitors_path.open("w") as f:
    f.write(f"monitor_left: {left}\n")
    f.write(f"monitor_right: {right}\n")

os.system(f"xrdb -merge {monitors_path}")
if left == right:
    sys.exit(0)
os.system(f"xrandr --output {right} --right-of {left}")
if len(other_monitors) == 1:
    os.system(f"xrandr --output {left} --right-of {other_monitors[0]}")
