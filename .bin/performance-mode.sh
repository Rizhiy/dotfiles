#!/bin/bash
# ThinkPad X1 Carbon Performance Mode Script
# Enables maximum CPU performance and cooling

echo "=== ThinkPad Performance Mode ==="
echo ""

# 1. Enable fan control if needed
fan_control=$(cat /sys/module/thinkpad_acpi/parameters/fan_control 2>/dev/null)
if [ "$fan_control" != "Y" ]; then
    echo "Enabling fan control..."
    echo "options thinkpad_acpi fan_control=1" | sudo tee /etc/modprobe.d/thinkpad_acpi.conf > /dev/null
    sudo modprobe -r thinkpad_acpi 2>/dev/null
    sudo modprobe thinkpad_acpi
    sleep 1
    echo "✓ Fan control enabled"
fi

# 2. Save current fan level
current_fan_level=$(grep "^level:" /proc/acpi/ibm/fan | awk '{print $2}')
echo "$current_fan_level" > /tmp/previous_fan_level
echo "Saved current fan level: $current_fan_level"
echo ""

# 3. Set CPU governor to performance
echo "Setting CPU governor to performance..."
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
echo "✓ CPU governor: performance"

# 4. Set energy performance preference to performance
echo "Setting energy performance preference..."
echo performance | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference > /dev/null
echo "✓ EPP: performance"

# 5. Set Intel P-state to maximum
echo "Setting Intel P-state..."
echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct > /dev/null
echo 50 | sudo tee /sys/devices/system/cpu/intel_pstate/min_perf_pct > /dev/null
echo "✓ Intel P-state: 50-100%"

# 6. Enable Turbo Boost
if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
    echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null
    echo "✓ Turbo Boost: enabled"
fi

# 7. Set fan to maximum speed
echo "Setting fan to maximum (disengaged)..."
echo level disengaged | sudo tee /proc/acpi/ibm/fan > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Fan: disengaged (maximum RPM)"
    echo ""
    echo "⚠ WARNING: Fan will run at maximum speed!"
else
    echo "⚠ Could not set fan to disengaged mode"
fi

# 8. Display status
echo ""
echo "=== Status ==="
echo "CPU: $(cat /proc/cpuinfo | grep "cpu MHz" | head -1 | awk '{print $4}') MHz (avg)"
sensors 2>/dev/null | grep -E "Package id 0:" | head -1 || echo "Temp: N/A"
echo "Fan: $(cat /proc/acpi/ibm/fan | grep speed | awk '{print $2}') RPM"
echo ""
echo "✓ Performance mode activated!"
echo "  Run 'powersave-mode.sh' to return to normal mode"
