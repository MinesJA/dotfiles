# TODO

## Secure Credential Management

### Task: Replace plain text credentials across system with encrypted storage

Currently have plain text credentials scattered across the system (e.g., `/etc/openvpn/auth.txt`). Need to implement secure credential management.

### Options:

1. **Pass (password-store)** - GPG-encrypted password manager (Recommended)
   ```bash
   # Install
   sudo pacman -S pass  # Arch
   sudo apt install pass  # Debian/Ubuntu
   
   # Setup
   pass init your-gpg-id
   pass insert vpn/nordvpn
   
   # Usage example
   pass show vpn/nordvpn | sudo openvpn --config file.ovpn --auth-user-pass /dev/stdin
   ```

2. **Keyring/Secret Service** - System credential manager
   ```bash
   # Store credential
   secret-tool store --label="NordVPN" service nordvpn username youruser
   
   # Retrieve credential
   secret-tool lookup service nordvpn
   ```

3. **Encrypted files with GPG**
   ```bash
   # Encrypt
   gpg -c auth.txt  # Creates auth.txt.gpg
   rm auth.txt      # Remove plain text version
   
   # Use
   gpg -d auth.txt.gpg 2>/dev/null | sudo openvpn --config file.ovpn --auth-user-pass /dev/stdin
   ```

4. **File permissions** (Minimum security - temporary measure)
   ```bash
   sudo chmod 600 /etc/openvpn/auth.txt
   sudo chown root:root /etc/openvpn/auth.txt
   ```

### Action Items:
- [ ] Audit system for all plain text credential files
- [ ] Choose credential management solution (recommend `pass`)
- [ ] Migrate existing credentials to secure storage
- [ ] Update scripts to use secure credential retrieval
- [ ] Remove all plain text credential files