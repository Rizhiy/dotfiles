#!/bin/bash
# ThinkPad X1 Carbon Power Save Mode Script
# Returns CPU and fan to power-saving defaults

echo "=== ThinkPad Power Save Mode ==="
echo ""

# 1. Set CPU governor to powersave
echo "Setting CPU governor to powersave..."
echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
echo "✓ CPU governor: powersave"

# 2. Set energy performance preference to balanced
echo "Setting energy performance preference..."
echo balance_performance | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference > /dev/null
echo "✓ EPP: balance_performance"

# 3. Reset Intel P-state to defaults
echo "Resetting Intel P-state..."
echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct > /dev/null
echo 9 | sudo tee /sys/devices/system/cpu/intel_pstate/min_perf_pct > /dev/null
echo "✓ Intel P-state: 9-100%"

# 4. Restore fan to previous setting or auto
echo "Restoring fan settings..."
if [ -f /tmp/previous_fan_level ]; then
    previous_level=$(cat /tmp/previous_fan_level)
    echo level $previous_level | sudo tee /proc/acpi/ibm/fan > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✓ Fan: $previous_level (restored)"
        rm /tmp/previous_fan_level
    else
        echo level auto | sudo tee /proc/acpi/ibm/fan > /dev/null 2>&1
        echo "✓ Fan: auto"
    fi
else
    echo level auto | sudo tee /proc/acpi/ibm/fan > /dev/null 2>&1
    echo "✓ Fan: auto"
fi

# 5. Display status
echo ""
echo "=== Status ==="
echo "CPU: $(cat /proc/cpuinfo | grep "cpu MHz" | head -1 | awk '{print $4}') MHz (avg)"
sensors 2>/dev/null | grep -E "Package id 0:" | head -1 || echo "Temp: N/A"
echo "Fan: $(cat /proc/acpi/ibm/fan | grep speed | awk '{print $2}') RPM"
echo ""
echo "✓ Power save mode activated!"
