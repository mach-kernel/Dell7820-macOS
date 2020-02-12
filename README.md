# Precision 7820 Hackintosh

macOS 10.15 Catalina on Dell Precision 7820 with [OpenCore](https://github.com/acidanthera/OpenCorePkg). Currently working with 10.15.3! If you find something broken, please make a PR!

The docs & tools that helped me set this up are here, a big thanks to:

- [OpenCore Vanilla Desktop Guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/)
- [RehabMan's SSDT USB port mapping](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)
- [USBMap](https://github.com/corpnewt/USBMap) and [SSDTTime](https://github.com/corpnewt/SSDTTime)
- [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/)

<img src="https://i.imgur.com/saOVNOM.png" width="500" />

## Getting Started

Point this at _EFI directory_ of a USB stick or the ESP from your new install. It will download OpenCore + all needed drivers and kernel extensions from the original authors.

```
./make_efi.sh path_to_efi_dir
```

## Hardware & Compatibility

I would love to hear feedback about this configuration from someone with a dual CPU machine!

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
- Sleep

### Not working / unknown
- Thunderbolt
- SD Card Reader
  - Supposedly this should be easy

## OpenCore Settings

It took a while to get everything into place, so an outline of `config.plist` may be useful for others.

### ACPI

#### Patches

- SSDTTime generated
  - TMR IRQ 0
  - RTC IRQ 8
  - HPET _CRS to XCRS
- From RehabMan tutorials
  - EHC1 to EH01
  - EHC2 to EH02
  - Rename XHCI to XHC
  - Rename XHC1 to XHC

#### SSDT

USB ports will not work without the RehabMan SSDTs below

- SSDTTime generated
  - HPET
  - PLUG
  - EC
- RehabMan
  - XOSI
  - UIAC for UsbInjectAll

### Booter

I haven't touched this since I was randomly toggling things on and off to avoid KPs, so maybe a bunch of this stuff can be disabled

#### Quirks

- `slide` related
  - EnableSafeModeSlide
  - DevirtualiseMmio
  - ProvideCustomSlide
- AvoidRuntimeDefrag
- ShrinkMemoryMap
- SetupVirtualMap
- EnableWriteUnprotector

### Kernel

The `*Xcpm` quirks are super important and the system will not boot without them

#### Add

- Lilu
- VirtualSMC
  - Does not need companion `VirtualSMC.efi` with OC
- SMCProcessor
- SMCSuperIO
- WhateverGreen
- IntelMausiEthernet
- VoodooHDA
  - If you want to use AppleALC, this machine is Layout ID 3. I couldn't get it to work. I am not experiencing any audio quality issues using Voodoo.
- USBInjectAll (with SSDT above)

#### Quirks

- AppleCpuPmCfgLock
- AppleXcpmCfgLock
- AppleXcpmExtraMsrs
  - Will refuse to boot without this
- DisableIoMapper
- ExternalDIskIcons
- PanicNoKextDump
- PowerTimeoutKernelPanic

### NVRam

Nothing crazy happening here. It will not boot without the npci flag.

`boot-args`: `npci=0x2000`

### PlatformInfo

I am using the `MacPro7,1` SMBIOS. I am not sure what effect if any the SMBIOS has on the behavior of the system. Please PR a more appropriate SMBIOS if available!
