# 🚀 ORBIT-OS

> **Vulkan-first rolling release Linux distribution based on Arch Linux.**

ORBIT-OS is a modern, lightweight Linux distribution built from scratch using `archiso`. Its unique feature is **native Vulkan preference** for rendering the KDE Plasma interface.

**ORBIT-OS is the only Linux distribution in the world that uses Vulkan (almost) natively for its desktop environment** – instead of OpenGL, which is the default in every other distribution.

## ✨ Key Features

- 🎨 **Vulkan-first** – Qt Quick rendered through Vulkan by default, with automatic fallback to OpenGL
- 🌍 **Unique in the world** – the only distribution shipping Vulkan as the default rendering backend for KDE Plasma
- 🔄 **Rolling release** – based on Arch Linux, always the freshest packages
- 💿 **Offline installer** – Calamares copies the system from the live ISO, no internet required (ANYWAY, I RECOMMEND USING IT FOR PROPER OPERATION!!!!!)
- ⚙️ **Universal installation** – NVMe, SATA, eMMC, UEFI and BIOS support
- 🌐 **Global** – multiple languages and time zones, English as default
- 🎵 **Cava built-in** – terminal music visualizer pre-installed
- 🎯 **Clean and minimal** – only essential KDE applications, no bloatware

## 📸 Screenshots

<img width="1920" height="1080" alt="1png" src="https://github.com/user-attachments/assets/164267c1-26bd-4b59-8fa7-9cb07891e42a" />
<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/fbd1b21c-c4d5-418d-9ed1-7bc9b058b5fc" />
<img width="1920" height="1080" alt="3" src="https://github.com/user-attachments/assets/ed7bad0a-cf7a-436d-b2b3-b5df6f2d2698" />
<img width="1920" height="1080" alt="4" src="https://github.com/user-attachments/assets/9bd3c91c-a03b-4dac-bd42-c0bb9586a4da" />
<img width="1920" height="1080" alt="5" src="https://github.com/user-attachments/assets/b9ea482f-e029-4264-8a1f-2153d1a3a63e" />


🚀 Quick Start
1. Write the ISO to a USB drive (Balena Etcher recommended)

We strongly recommend using Balena Etcher to write the ISO to a USB drive. It is completely free, works on Windows, Linux, and macOS, and automatically verifies the write to ensure your USB drive is not corrupted.

How to use Balena Etcher:

Download Balena Etcher for your operating system from etcher.balena.io:

Windows: Download the .exe installer and run it.

Linux: Download the .AppImage file, make it executable (chmod +x balenaEtcher-*.AppImage), and run it. Alternatively, install it via your distribution's package manager.

macOS: Download the .dmg file and drag it to your Applications folder.
Launch Balena Etcher.

Click “Flash from file” and select the orbit-os-1.0-1.0-x86_64.iso file you downloaded.

Click “Select target” and choose your USB drive. (Etcher automatically hides system drives to prevent accidental selection).

Click “Flash!” and wait for the process to complete. Etcher will automatically verify the write when finished.

Alternative for Linux/macOS – the dd method:

If you are on Linux or macOS and prefer the classic terminal approach, you can use dd. Warning: this will completely erase the entire USB drive.

Open your terminal.

Identify your USB drive using "lsblk" (Linux) or "diskutil list" (macOS).

Run the following command (replace /dev/sdX with your USB drive, e.g., /dev/sdb, not /dev/sdb1):
bash

    sudo dd if=orbit-os-1.0-1.0-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync

2. Boot and install

    Boot from the USB drive (you may need to change the boot order in your BIOS/UEFI settings).

    Select ORBIT-OS 1.0 (x86_64, UEFI) in the boot menu.

    Wait for the KDE Plasma desktop to load.

    Double-click Install ORBIT-OS on the desktop.

    Follow the Calamares installer steps.

⚙️ Post-Installation Setup

After installing ORBIT-OS on your hard drive, you need to disable the local orbit-repo repository in pacman.conf. This repository is only used during the ISO build process and will cause pacman errors if left enabled on your installed system.
How to disable orbit-repo

Open Dolphin (file manager)

Navigate to /etc/

Right-click on pacman.conf → Open with Kate (you will be asked for your sudo password)

Find the following lines:
ini

    [orbit-repo]
    SigLevel = Optional TrustAll
    Server = file:///home/chris/orbit-repo

Comment them out by adding # at the beginning of each line:
ini

    #[orbit-repo]
    #SigLevel = Optional TrustAll
    #Server = file:///home/chris/orbit-repo

Save the file (Ctrl+S) and close Kate

Now pacman will work correctly, using only the official Arch Linux mirrors.
Optional: Change your timezone and language

ORBIT-OS ships with English and UTC as defaults. To change them:

Timezone: System Settings → Date & Time

Language: System Settings → Region & Language

🎵 Cava – Terminal Music Visualizer

ORBIT-OS ships with Cava pre-installed – a lightweight, beautiful music visualizer for the terminal.

To run it, simply open Konsole and type:
bash

    cava
 ### 2. Download the ISO

 HOW TO DOWNLOAD ORBIT OS? SO YES, YOU NEED TO GO TO THE https://github.com/CHRIS220011/orbit-os/releases, THEN CHOOSE THE VERSION AND DOWNLOAD IT!,This system is hosted on MEGA.

 ### WARNING!!!!!!
In version 1.0,WARNING!!! BY DEFAULT, THE LOGIN SCREEN DOES NOT WORK. TO FIX THIS, GO TO SYSTEM SETTINGS, THEN CLICK GLOBAL APPEARANCE, AND THEN LOGIN SCREEN (SDDM), AND THEN CHOOSE WHICHEVER ONE YOU WANT, AND THEN CLICK  APPLY. AFTER DOING THIS, RESTART YOUR PC, AND THE LOGIN SCREEN SHOULD WORK CORRECTLY. THIS WILL BE FIXED IN LATER VERSIONS!


Play any music (e.g. in VLC, Firefox, or Spotify) and Cava will react in real time. Perfect for showing off ORBIT-OS to your friends.
The resulting ISO will be placed in the ./out/ directory.
📚 Documentation

Full project documentation, including detailed installation, configuration and troubleshooting guides, is available in the docs/ directory.
🤝 Contributing

Contributions are welcome! Before you start, please read CONTRIBUTING.md, which describes how to report bugs and propose changes. Please also follow our CODE_OF_CONDUCT.md.
📄 License

This project is released under the GNU General Public License v3.0. See the LICENSE file for details.
🙏 Credits
Based on Arch Linux 

Built with archiso

Installer: Calamares

Desktop: KDE Plasma

Music visualizer: Cava
