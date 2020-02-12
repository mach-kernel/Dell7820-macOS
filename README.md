# Precision 7820 Hackintosh

macOS 10.15 Catalina on Dell Precision 7820 with [OpenCore](https://github.com/acidanthera/OpenCorePkg). Currently working with 10.15.3! Produced this configuration with the following tools and docs:

- [OpenCore Vanilla Desktop Guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/)
- [RehabMan's SSDT USB port mapping](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)
- [USBMap](https://github.com/corpnewt/USBMap) and [SSDTTime](https://github.com/corpnewt/SSDTTime)
- [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/)

<img src="https://i.imgur.com/saOVNOM.png" width="500" />

## Getting Started

Point this at _EFI directory_ of a USB stick or the ESP from your new install.

```
./make_efi.sh path_to_efi_dir
```

## Hardware & Compatibility

### It works on my machine™
- 1x Xeon Silver 4114
- 32 GB DDR4 2400
- AMD 7870
  - If someone else has this old thing, add `radgpu=15` to your kernel args

### Working
- USB 3 A/C
- USB 2
- Audio
- Ethernet

### Not working / unknown
- Thunderbolt
- SD Card Reader

