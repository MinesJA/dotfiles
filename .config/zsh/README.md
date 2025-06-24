# ZSH Configuration Files

This directory contains ZSH configuration files for aliases, functions, and environment variables.

## Files

- `aliases.zsh` - General command aliases (public, tracked in git)
- `git_aliases.zsh` - Git-specific aliases (public, tracked in git)
- `kubectl_aliases.zsh` - Kubernetes kubectl aliases (public, tracked in git)
- `work_aliases.zsh` - Work-specific aliases (private, gitignored)
- `secrets.zsh` - Sensitive environment variables like API tokens (private, gitignored)
- `secrets.zsh.example` - Template for secrets.zsh file

## Setting up secrets

1. Copy the example file:
   ```bash
   cp secrets.zsh.example secrets.zsh
   ```

2. Edit `secrets.zsh` and add your actual tokens/secrets

3. The file is automatically gitignored and will be sourced by `.zshrc`

## Security Features

- **Git Protection**: Pre-commit hooks prevent accidental secret commits
- **File Separation**: Secrets are isolated from public configuration files
- **Automatic Sourcing**: Environment variables are loaded automatically by `.zshrc`

## Security Best Practices

- Never commit `secrets.zsh` or `work_aliases.zsh` to version control
- Regularly rotate your API tokens and credentials
- Use token expiration dates when creating new tokens
- Use minimal permission scopes for API tokens
- Consider using a password manager CLI for enhanced security

### Password Manager Integration

For enhanced security, integrate with password manager CLIs:

```bash
# Using pass (Unix password store)
export GITHUB_TOKEN=$(pass show github/token)

# Using 1Password CLI
export GITHUB_TOKEN=$(op item get "GitHub Token" --field token)

# Using Bitwarden CLI
export GITHUB_TOKEN=$(bw get password github-token)
```

### Git Hooks Setup

Run the setup script to install pre-commit hooks:
```bash
./setup-git-hooks.sh
```

This will prevent accidental commits of:
- GitHub tokens (ghp_*, github_pat_*, ghs_*)
- Private keys
- AWS access keys
- OpenAI API keys
- Forbidden files (secrets.zsh, .env, .envrc)