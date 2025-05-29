# VPN

### After creating vpn instance, login in to server 

```
ssh -i c:/repos/key-pair.pub openvpnas@<vpn_public_ip>
```
- aggrement: yes
- password: Abcd@1234 (give any password)
- remaining all enter

### OpenVPN server configuration

- Open Admin UI link in browser → Username: openvpn → Password: Abcd@1234 → agree → VPN settings → should client internet traffic be routed through VPN (yes) → Have clients use specific DNS servers (yes) → Private DNS server (8.8.8.8) → Secondary DNS server (8.8.4.4) → save settings → update running server 

### OpenVPN server configuration

- Open browser → search open vpn client → download openvpn connect → open openvpn in your laptop after downloaded → URL: client UI url → next → accept → Username: openvpn → Password: Abcd@1234 → Import → On VPN

- Open browser → Search "MyIPaddress" website → we can see our IPV4 as "VPN public IP" and "location US Virginia"