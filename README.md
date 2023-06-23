# cOS - An Operating System

## Boot and run

1. Create an image (iso) from source code
2. Use `qemu` to create a new virtual machine
3. Run and play

### Create an image

### Load up new virtual machine with image

`qemu-img create -f qcow2 mydisk.qcow2 15G`

```
qemu-system-x86_64 \
-m 8G \
-smp 6 \
-cdrom /Volumes/Samsung_T5/iso/Fedora-Workstation-Live-x86_64-35-1.2.iso \
-drive file=mydisk.qcow2,if=virtio \
-vga virtio \
-display default,show-cursor=on \
-usb \
-device usb-tablet \
-cpu host \
-machine type=q35,accel=hvf \
```
