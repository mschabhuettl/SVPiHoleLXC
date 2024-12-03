<div align="center">
  <a href="#">
    <img src="https://raw.githubusercontent.com/mschabhuettl/PiBlockLXC/main/misc/images/logo.png" height="150px" />
 </a>
</div>
<h1 align="center">PiBlockLXC - Advanced Pi-hole LXC with RPiList and Comprehensive Enhancements</h1>

<div align="center">
  <img src="https://avatars.githubusercontent.com/u/56664851" alt="RPiList" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
  <img src="https://github.com/home-assistant/brands/blob/master/core_integrations/pi_hole/icon.png?raw=true" alt="Pi-hole" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
  <img src="https://avatars.githubusercontent.com/u/8418678" alt="pihole-updatelists" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
  <img src="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/images/logo-81x112.png" alt="Proxmox VE Helper-Scripts" height="100" />
  <img src="https://emojicdn.elk.sh/🤝" alt="Handshake" height="50" />
  <img src="https://avatars.githubusercontent.com/u/2678585" alt="Proxmox" height="100" />
</div>

A project to simplify the installation of [Pi-hole](https://pi-hole.net/) in an LXC container on Proxmox, automatically extended with lists from [RPiList/specials](https://github.com/RPiList/specials) and [Firebog](https://v.firebog.net/hosts/lists.php).

## About the Project

This project builds on the helper scripts from the late [tteck/Proxmox](https://github.com/tteck/Proxmox), whose work laid the foundation for creating LXC containers on Proxmox. Following his passing, the Proxmox helper scripts have been continued as a community project under [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE). This project extends those scripts by integrating lists from [RPiList/specials](https://github.com/RPiList/specials) and [Firebog](https://v.firebog.net/hosts/lists.php). The goal is to simplify the setup of a Pi-hole LXC container on a Proxmox server, adding a curated selection of blocklists for ads, tracking, and potentially harmful websites to the Pi-hole base installation.

## Features

- Utilizes the foundational script from [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE) for LXC creation.
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
bash -c "$(wget -qLO - https://github.com/mschabhuettl/PiBlockLXC/raw/main/ct/piblocklxc.sh)"
```

### ⚡ Default Settings

- **RAM:** 1024MiB
- **Storage:** 16GB
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

For pihole-updatelists to function correctly, a specific configuration file is required. The script facilitates this by downloading a [pre-configured configuration file](https://raw.githubusercontent.com/mschabhuettl/PiBlockLXC/main/config/pihole-updatelists.conf) from this repository. This file contains settings that dictate which remote sources to use for updating Pi-hole's lists, effectively streamlining the setup process and ensuring that pihole-updatelists is ready to operate with minimal user intervention.

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

## Customizing Your Whitelist and Blacklist

Enhancing the balance between security and accessibility on your network involves meticulous curation of both blacklists and whitelists. This project integrates these lists to filter out unwanted content while ensuring access to necessary resources. Here's how to tailor these lists to fit your specific needs:

### Integrated Lists

- **Blacklists**: We incorporate comprehensive blacklists from sources such as [RPiList/specials](https://github.com/RPiList/specials), [Firebog](https://v.firebog.net/hosts/lists.php?type=all), and [StevenBlack](https://github.com/StevenBlack/hosts), ensuring robust protection against intrusive ads, trackers, and malicious sites.

- **Whitelists**: To maintain access to essential and commonly used domains, whitelists from [anudeepND/whitelist](https://github.com/anudeepND/whitelist) and [RPiList/specials](https://github.com/RPiList/specials) are used. These lists are curated to minimize the chances of blocking legitimate websites, ensuring a seamless browsing experience.

<details>
<summary><b>Optional Whitelist URLs</b></summary>

For users who require specific functionalities from services like Slickdeals, Fatwallet, or similar platforms, it may be necessary to whitelist certain domains that are generally classified as trackers or ads. Here are additional lists from anudeepND that can be included in your `WHITELIST_URL` section if needed:

- **Referral Sites**: People who use services like Slickdeals and Fatwallet need a few sites (most of them are either trackers or ads) to be whitelisted to work properly. This file contains some analytics and ad serving sites like doubleclick.net and others. If you don't know what these services are, stay away from this list.
  - URL: `https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/referral-sites.txt`

- **Optional List**: This file contains domains that are needed to be whitelisted depending on the service you use. It may contain some tracking sites, but sometimes it's necessary to add bad domains to make a few services work. Currently, there is no script for this list, you have to add domains manually to your Pi-Hole.
  - URL: `https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt`

To include these lists, add their URLs to the `WHITELIST_URL` section of your `pihole-updatelists.conf` file. Remember, you can always remove these entries if you find them unnecessary for your usage or if you prefer to minimize exposure to tracking and ads.

</details>

### Configuring `pihole-updatelists.conf`

For detailed customization of your filter lists, we recommend reviewing the `pihole-updatelists.conf` configuration file. In this file, you'll find the URLs for the blacklists and whitelists, which you can adjust as needed. You can add lists that are relevant to your specific requirements or remove those you do not need.

- **Adding/Removing Lists**: Directly insert URLs for additional lists into the `pihole-updatelists.conf` or remove entries that are not needed. This gives you full control over the content that is filtered or allowed.

- **Updating Lists**: After making changes to the `pihole-updatelists.conf`, please execute `pihole-updatelists` to apply your adjustments and update the lists accordingly.

This flexibility allows you to create a Pi-hole experience tailored to your needs by ensuring that only the content you want is filtered.

### Conclusion

Tailoring your whitelist and blacklist provides a proactive approach to managing internet content, striking an optimal balance between safeguarding your network and ensuring seamless access to legitimate websites. By fine-tuning these lists, you can enhance your online experience, prioritizing both security and functionality to meet your unique needs.

## Support and Contributions

Feedback, suggestions, and contributions are welcome! If you'd like to help improve this project, please feel free to create issues or pull requests. Your input is valuable, and I appreciate any contributions you can make. Thank you for considering helping out!

## Acknowledgements

- [tteck/Proxmox](https://github.com/tteck/Proxmox) for the foundational Proxmox helper scripts.
- [RPiList/specials](https://github.com/RPiList/specials) for the comprehensive lists protecting against fake shops and more.
- [Firebog](https://v.firebog.net/hosts/lists.php) for the curated blocklists.
- [jacklul/pihole-updatelists](https://github.com/jacklul/pihole-updatelists) for the script enabling automatic list updates.
- **[anudeepND/whitelist](https://github.com/anudeepND/whitelist)** for offering a robust collection of commonly whitelisted websites, ensuring essential and frequently used sites remain accessible, contributing to a balanced and efficient ad-blocking setup.

## Logo Acknowledgement

The logo for this project, depicting a cat embracing a raspberry, was uniquely generated by OpenAI's DALL·E, a state-of-the-art AI model specialized in creating images from textual descriptions. We opted for a cat motif to symbolize the project's connection to the internet, where cats reign supreme as symbols of curiosity and technological whimsy. This choice captures the essence of our initiative — a friendly and innovative approach to network security, presented in a unique and creative design.

Why feature a cat? In the realm of the digital age, cats transcend their role as mere pets to become icons of internet culture. From viral videos to memes, cats and the internet are inextricably linked. The cat in our logo represents not only the playful and accessible side of technology but also the wisdom and agility with which we navigate the complexities of network security. This logo was crafted with DALL·E, highlighting our project's innovative spirit and commitment to blending technology with creativity.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/mschabhuettl/PiBlockLXC/blob/main/LICENSE) file for details.

Pi-hole® is a registered trademark of Pi-hole LLC.  
Proxmox® is a registered trademark of Proxmox Server Solutions GmbH.  
This project is not affiliated with Pi-hole or Proxmox.
