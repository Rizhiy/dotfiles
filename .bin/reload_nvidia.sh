# Stop graphical interface
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
