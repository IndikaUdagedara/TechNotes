# TP-Link

## Deco Ethernet Backhaul

Source: https://www.tp-link.com/au/support/faq/1794/

### What is Ethernet Backhaul?
Wires Deco units together via Ethernet cable. Data travels over the wired link (more stable and faster than Wi-Fi); Wi-Fi backhaul disconnects automatically once Ethernet backhaul is established.

### Setup
1. Set up all Deco units on the same Wi-Fi network via the Deco app first.
2. Wire satellite Deco to a LAN port on the main Deco (or a switch off the main Deco's LAN port) — **not** the WAN/internet port. This avoids a network loop.
3. In Access Point mode, satellite Deco can be wired to any unit or the main modem/router.
4. Check connection type in the Deco app: network map → tap satellite unit.

### Switch Compatibility
- Most unmanaged switches work fine.
- Some switches (notably D-Link) don't forward IEEE 1905.1 multicast packets — causes instability/loops.
- If a switch has loop detection enabled it may block Deco's backhaul port; disable loop detection and reboot the switch.
- Verified compatible TP-Link switches: TL-SX1008 (10G), TL-SG108 (1G), TL-SG3210 (managed).

### Troubleshooting
- IPTV port cannot be used for backhaul.
- Try a different port or cable.
- Connect two Deco units directly (bypassing the switch) to isolate switch issues.
- On the main Deco, one port = internet (modem), the other = backhaul or device.

### Misc
- Different Deco models (e.g. M5 + M9 Plus) can be mixed in the same network and use Ethernet backhaul together.
- To disable: just unplug the Ethernet cable between units.
- One Ethernet port on a Deco can be used for backhaul, the other for a local device.
- Cross-floor wiring is supported (Router mode: satellite must connect to main Deco's LAN or a downstream switch, not directly to the modem).