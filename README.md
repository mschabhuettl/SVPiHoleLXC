# SVPiHoleLXC - Pi-hole LXC with RPiList and Firebog Lists

<div align="center">
  <div style="display: flex; align-items: center; justify-content: center;">
    <div>
      <img src="https://avatars.githubusercontent.com/u/56664851" alt="RPiList" height="100" />
    </div>
    <div style="margin: 0 20px;">
      <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
    </div>
    <div>
      <img src="https://github.com/home-assistant/brands/blob/master/core_integrations/pi_hole/icon.png?raw=true" alt="Pi-hole" height="100" />
    </div>
    <div style="margin: 0 20px;">
      <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
    </div>
    <div>
      <img src="https://avatars.githubusercontent.com/u/8418678" alt="pihole-updatelists" height="100" />
    </div>
    <div style="margin: 0 20px;">
      <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
    </div>
    <div>
      <img src="https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/logo-81x112.png" alt="Proxmox VE Helper-Scripts" height="100" />
    </div>
    <div style="margin: 0 20px;">
      <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
    </div>
    <div>
      <img src="https://avatars.githubusercontent.com/u/2678585" alt="Proxmox" height="100" />
    </div>
  </div>
</div>

A project to simplify the installation of [Pi-hole](https://pi-hole.net/) in an LXC container on Proxmox, automatically extended with lists from [RPiList/specials](https://github.com/RPiList/specials) and [Firebog](https://v.firebog.net/hosts/lists.php).

## About the Project

This project builds on the helper scripts from [tteck/Proxmox](https://github.com/tteck/Proxmox) and extends them by automatically integrating lists from [RPiList/specials](https://github.com/RPiList/specials) and [Firebog](https://v.firebog.net/hosts/lists.php). The goal is to simplify the setup of a Pi-hole LXC container on a Proxmox server by adding a selection of blocklists for ads, tracking, and potentially harmful websites to the Pi-hole base installation.

## Features

- Utilizes the foundational script from [tteck](https://github.com/tteck/Proxmox) for LXC creation.
- Automatically integrates blocklists from [RPiList/specials](https://github.com/RPiList/specials) and [Firebog](https://v.firebog.net/hosts/lists.php) through [jacklul/pihole-updatelists](https://github.com/jacklul/pihole-updatelists).
- Simplifies the deployment of a Pi-hole LXC container with pre-configured blocklists for enhanced network protection.

## Pi-hole Overview

<p align="center">
  <img src="https://github.com/home-assistant/brands/blob/master/core_integrations/pi_hole/icon.png?raw=true" height="100">
</p>

[Pi-hole](https://pi-hole.net/) is a free, open-source application for blocking unwanted internet content at the network level. It serves as a DNS sinkhole to block ads, trackers, and other unwanted traffic before it reaches user devices. Pi-hole can also function as a DHCP server, offering further network management capabilities. Highly customizable, it allows for detailed configuration to meet users' privacy and security needs.

## Quick Start

To create a new Proxmox VE Pi-hole LXC, execute the following command in the Proxmox VE Shell:

```bash
bash -c "$(wget -qLO - https://github.com/mschabhuettl/SVPiHoleLXC/raw/main/ct/svpihole.sh)"
```

### ⚡ Default Settings

- **RAM:** 1024MiB
- **Storage:** 8GB
- **CPU:** 2vCPU

### Pi-hole updatelists Integration

The script includes an option to integrate `pihole-updatelists`, a powerful tool for managing Pi-hole's blocklists, whitelists, and blacklists automatically by fetching updates from specified remote sources.

#### Installation Prompt for pihole-updatelists

During the setup, you will be prompted to decide if you wish to add `pihole-updatelists`:

```bash
Would you like to add pihole-updatelists? <Y/n>
```

Choosing yes (default setting and **recommended**) initiates the configuration of `pihole-updatelists`.

This step is crucial for automating the update of your lists directly from remote sources, ensuring your Pi-hole setup remains effective against ads, trackers, and malicious sites without manual intervention.

#### Schedule Configuration and System Overrides

To avoid any conflicts with the default Pi-hole update tasks and to tailor the update frequency for your environment, the script sets up a custom schedule for `pihole-updatelists`. Specifically, it disables Pi-hole's built-in updateGravity job within the crontab to prevent any overlap. Then, it establishes a daily trigger for `pihole-updatelists` to run at 03:00 AM, ensuring that list updates are processed during off-peak hours to minimize any potential impact on your network's performance.

#### Setting up pihole-updatelists Configuration

For pihole-updatelists to function correctly, a specific configuration file is required. The script facilitates this by downloading a [pre-configured configuration file](https://raw.githubusercontent.com/mschabhuettl/SVPiHoleLXC/main/config/pihole-updatelists.conf) from this repository. This file contains settings that dictate which remote sources to use for updating Pi-hole's lists, effectively streamlining the setup process and ensuring that pihole-updatelists is ready to operate with minimal user intervention.

#### Executing the Initial List Update

With `pihole-updatelists` installed and configured, the script executes an initial update to apply the newly specified settings immediately. This initial run fetches the latest versions of your specified blocklists, whitelists, and blacklists from their remote sources and integrates them into your Pi-hole setup. By doing so, it enhances Pi-hole's filtering capabilities from the get-go, offering an improved level of protection against unwanted internet content.

In summary, the inclusion of `pihole-updatelists` in the setup process introduces a layer of automation to Pi-hole's list management, significantly reducing the need for manual updates and ensuring that your network benefits from the latest list updates without additional user effort.

# Post-Install

## Setting Your Password

To set or update your Pi-hole admin password, use the following command:

```bash
pihole -a -p
```

**Note:** Please reboot the Pi-hole LXC after installation.

**Accessing Pi-hole Interface:** `IP_OF_YOUR_PIHOLE/admin`

## Configuration

After installation, you can customize the configuration of Pi-hole via its web interface or by editing the configuration files in the `/etc/pihole/` directory.

For automatic list updates via `pihole-updatelists`, you'll find the configuration file at `/etc/pihole-updatelists.conf`.

## Support and Contributions

Feedback, suggestions, and contributions are welcome! If you'd like to help improve this project, please feel free to create issues or pull requests. Your input is valuable, and I appreciate any contributions you can make. Thank you for considering helping out!

## Acknowledgements

- [tteck/Proxmox](https://github.com/tteck/Proxmox) for the foundational Proxmox helper scripts.
- [RPiList/specials](https://github.com/RPiList/specials) for the comprehensive lists protecting against fake shops and more.
- [Firebog](https://v.firebog.net/hosts/lists.php) for the curated blocklists.
- [jacklul/pihole-updatelists](https://github.com/jacklul/pihole-updatelists) for the script enabling automatic list updates.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/mschabhuettl/SVPiHoleLXC/blob/main/LICENSE) file for details.

Pi-hole® is a registered trademark of Pi-hole LLC.  
Proxmox® is a registered trademark of Proxmox Server Solutions GmbH.  
This project is not affiliated with Pi-hole or Proxmox.
