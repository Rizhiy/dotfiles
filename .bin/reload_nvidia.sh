# Stop graphical interface
if [ $(id -u ) -ne 0 ]; then
    echo "This script needs to be run as sudo!"
    exit
fi
systemctl isolate multi-user.target
# Unload all nvidia modules
modprobe -r nvidia_uvm
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia
# Load nvidia-modules
nvidia-smi
# Start graphical interface
systemctl start graphical.target
