# Dotfiles TODO

## Setup .gitconfig to be compatible with work and personal
# Git Config Options for Multiple Machines

### Method 1: Conditional Includes (Best for Most Cases)

Create machine-specific config files and use Git's conditional includes:

**Main `.gitconfig`:**
```ini
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
[includeIf "gitdir:/Users/john/company-repos/"]
    path = ~/.gitconfig-work

# Default config for everything else
[user]
    name = John Doe
    email = john@personal.com

[core]
    editor = code --wait
# ... other shared settings
```

**`.gitconfig-work`:**
```ini
[user]
    name = John Doe
    email = john.doe@company.com
    signingkey = ABC123
```

**`.gitconfig-personal`:**
```ini
[user]
    name = John Doe
    email = john@personal.com
    signingkey = XYZ789
```

### Method 2: Local Override File (Simplest)

**Main `.gitconfig`:**
```ini
# Shared configuration
[core]
    editor = code --wait
[init]
    defaultBranch = main
# ... other shared settings

# Include local overrides (this file is gitignored)
[include]
    path = ~/.gitconfig.local
```

**`.gitconfig.local` (gitignored):**
```ini
[user]
    name = John Doe
    email = john.doe@company.com
```

**In your dotfiles repo:**
- Add `.gitconfig.local` to `.gitignore`
- Create `.gitconfig.local.example` with template

### Method 3: Environment-Based Template

Use a simple script or Makefile to generate the config:

**`.gitconfig.template`:**
```ini
[user]
    name = ${GIT_USER_NAME}
    email = ${GIT_USER_EMAIL}

[core]
    editor = code --wait
# ... other settings
```

**Setup script:**
```bash
#!/bin/bash
if [[ "$HOSTNAME" == *"work"* ]]; then
    export GIT_USER_EMAIL="john.doe@company.com"
else
    export GIT_USER_EMAIL="john@personal.com"
fi
export GIT_USER_NAME="John Doe"

envsubst < .gitconfig.template > ~/.gitconfig
```

### Method 4: Hostname-Based Detection

**`.gitconfig`:**
```ini
[includeIf "onbranch:**"]
    path = ~/.gitconfig-common

# This gets processed by your dotfiles setup script
# HOSTNAME_CONFIG_INCLUDE
```

Then your setup script replaces `# HOSTNAME_CONFIG_INCLUDE` with the appropriate include.

### Recommendation

**Use Method 1 (Conditional Includes)** if you organize your repos by work/personal directories. It's the cleanest and most Git-native approach.

**Use Method 2 (Local Override)** if you want the simplest setup with minimal configuration. Just remember to create the `.gitconfig.local` file on each machine.

Both approaches keep your dotfiles repo clean while allowing machine-specific customization.

## Docker-based Development Environment

**Goal**: Set up development in Docker containers to avoid installing packages/gems locally while maintaining LSP support in nvim.

### Background
- Currently developing in repos under the `firstup` directory
- Using nvim as primary IDE with LSP support
- Want to avoid local installation of Ruby gems and Node packages
- Need LSP servers to work properly inside containers

### Implementation Plan

#### 1. Create Dev Container Configuration
- [ ] Add `.devcontainer` directory to dotfiles with reusable Docker configurations
- [ ] Create base Dockerfiles:
  - Ruby development (with solargraph, rubocop, etc.)
  - Node.js/TypeScript development (with typescript-language-server, eslint, etc.)
- [ ] Configure volume mounts to share dotfiles and nvim config inside containers

#### 2. Set up Docker Compose Templates
- [ ] Ruby/Rails template for projects like:
  - hermes (Rails 7.2.2.1, Ruby 3.3.3)
  - governor
  - bossanova
  - apollo
  - hedwig
- [ ] Node.js/TypeScript template for projects like:
  - eva (Node >=16.14.0)
  - consensus
  - athena
  - deejay
- [ ] Include common services:
  - PostgreSQL
  - Redis
  - Elasticsearch (for projects that need it)

#### 3. Configure LSP Support
- [ ] Install language servers inside Docker containers
- [ ] Mount nvim configuration with proper paths
- [ ] Set up LSP to detect and use container-based servers
- [ ] Configure Mason.nvim to work with containerized environments

#### 4. Create Helper Scripts
- [ ] Shell function to spin up dev container for current project
- [ ] Auto-detection script for project type (Ruby/Node/Go/etc.)
- [ ] Aliases for common operations:
  - `dev-up`: Start development container
  - `dev-nvim`: Attach nvim to running container
  - `dev-shell`: Get shell in development container

#### 5. Integration with Existing Tools
- [ ] Ensure tmux works inside containers
- [ ] Set up SSH agent forwarding for git operations
- [ ] Configure Docker volumes for:
  - Gem cache (~/.gem)
  - npm/yarn cache (~/.npm, ~/.yarn)
  - ASDF installations
- [ ] Handle environment variables and secrets

### Example Docker Compose Structure

```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  dev:
    build:
      context: .
      dockerfile: .devcontainer/Dockerfile.ruby
    volumes:
      - .:/workspace
      - ~/.config/nvim:/home/developer/.config/nvim
      - ~/.gitconfig:/home/developer/.gitconfig
      - ~/.ssh:/home/developer/.ssh:ro
      - gem_cache:/usr/local/bundle
    environment:
      - BUNDLE_PATH=/usr/local/bundle
    command: /bin/bash

volumes:
  gem_cache:
```

### Benefits
- No local Ruby/Node version conflicts
- Clean system (no global gem/npm pollution)
- LSP servers have access to all project dependencies
- Consistent environments across projects
- Easy onboarding for new projects
- Can run multiple versions simultaneously

### References
- VS Code Dev Containers: https://code.visualstudio.com/docs/remote/containers
- Neovim in Docker: https://github.com/jesseduffield/lazydocker
- Docker Best Practices: https://docs.docker.com/develop/dev-best-practices/

### Notes
- Consider using Docker BuildKit for faster builds
- May want to create a separate repo for shared Docker configurations
- Could integrate with direnv for automatic container activation

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

## Look into Claude Github Actions
https://docs.anthropic.com/en/docs/claude-code/github-actions
