# Security Guide for Dotfiles

This document outlines security best practices for managing sensitive information in this dotfiles repository.

## Environment Variables and Secrets Management

### Overview
This repository implements a secure approach to managing environment variables and API tokens by separating public configuration from private secrets.

### File Structure
```
.config/zsh/
├── tokens.zsh           # Private tokens/secrets (gitignored)
├── tokens.zsh.example   # Template file (public)
├── aliases.zsh          # Public aliases
└── git_aliases.zsh      # Public git aliases
```

### Setup Process

1. **Copy the template file:**
   ```bash
   cp .config/zsh/tokens.zsh.example .config/zsh/tokens.zsh
   ```

2. **Edit tokens.zsh with your actual values:**
   ```bash
   # Edit the file and replace placeholders with real tokens
   vim .config/zsh/tokens.zsh
   ```

3. **Install git hooks for protection:**
   ```bash
   ./setup-git-hooks.sh
   ```

## Security Features

### Git Protection
- **Gitignore**: `tokens.zsh` is automatically excluded from version control
- **Pre-commit hooks**: Detect and prevent accidental secret commits
- **Template files**: Provide examples without exposing real values

### Automatic Loading
- Tokens are automatically sourced by `.zshrc` when the shell starts
- Conditional loading prevents errors if the file doesn't exist

## Protected Secret Types

The pre-commit hooks detect and block:
- **GitHub tokens**: `ghp_*`, `github_pat_*`, `ghs_*`
- **Private keys**: RSA, DSA, EC, OpenSSH private keys
- **AWS access keys**: `AKIA*` patterns
- **OpenAI API keys**: `sk-*` patterns
- **Forbidden files**: `tokens.zsh`, `secrets.zsh`, `.env`, `.envrc`

## Best Practices

### Token Management
1. **Use expiration dates** when creating new tokens
2. **Use minimal scopes** - only grant necessary permissions
3. **Rotate regularly** - set calendar reminders for token rotation
4. **Monitor usage** - check token usage in provider dashboards
5. **Avoid .gitconfig tokens** - use environment variables instead of git config

### Password Manager Integration
For enhanced security, consider using password manager CLIs:

```bash
# Pass (Unix password store)
export GITHUB_TOKEN=$(pass show github/token)

# 1Password CLI
export GITHUB_TOKEN=$(op item get "GitHub Token" --field token)

# Bitwarden CLI
export GITHUB_TOKEN=$(bw get password github-token)
```

### Environment-Specific Loading
Create environment-specific secret files:

```bash
# In .zshrc or tokens.zsh
if [[ $(hostname) == "work-laptop" ]]; then
    source ~/.config/zsh/work-tokens.zsh
elif [[ $(hostname) == "personal-machine" ]]; then
    source ~/.config/zsh/personal-tokens.zsh
fi
```

## Security Incidents

### If Secrets Are Exposed
1. **Immediately revoke** the exposed tokens at the provider
2. **Generate new tokens** with appropriate scopes and expiration
3. **Update secrets.zsh** with the new tokens
4. **Consider cleaning git history** if secrets were committed:
   ```bash
   # Use BFG Repo-Cleaner or git filter-branch
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch .config/zsh/tokens.zsh' \
     --prune-empty --tag-name-filter cat -- --all
   ```

### Emergency Response
If you accidentally commit secrets:
1. **Stop immediately** - don't push if you haven't already
2. **Reset the commit**: `git reset HEAD~1`
3. **Revoke the exposed tokens**
4. **Create new tokens**
5. **Update your tokens.zsh file**

## Advanced Security

### Multiple Token Management
```bash
# Different tokens for different purposes
export GITHUB_PERSONAL_TOKEN="ghp_personal_token"
export GITHUB_WORK_TOKEN="ghp_work_token"
export GITHUB_CI_TOKEN="ghp_ci_token"
```

### Conditional Token Loading
```bash
# Load different tokens based on directory
if [[ "$PWD" == *"/work/"* ]]; then
    export GITHUB_TOKEN="$GITHUB_WORK_TOKEN"
else
    export GITHUB_TOKEN="$GITHUB_PERSONAL_TOKEN"
fi
```

## Verification

### Test Your Setup
1. **Check gitignore**: `git check-ignore .config/zsh/tokens.zsh` should return the filename
2. **Test pre-commit**: Try committing a fake token to verify the hook works
3. **Verify loading**: `echo $GITHUB_TOKEN` should show your token after shell restart

### Regular Audits
- Review your tokens.zsh file quarterly
- Check for unused tokens and remove them
- Verify token permissions are still minimal
- Update token expiration dates

## Support

For questions about security practices or to report security issues:
1. Check this documentation first
2. Review the `.config/zsh/README.md` file
3. Create an issue in the repository (for non-sensitive questions only)

Remember: **Never include actual tokens or secrets in issue reports or public discussions.**