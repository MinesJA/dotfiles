#!/usr/bin/env bash
# Setup script to install git hooks for secret detection

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR="$SCRIPT_DIR/.git"
HOOKS_DIR="$GIT_DIR/hooks"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Setting up git hooks...${NC}"

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Link pre-commit hook
if [ -f "$SCRIPT_DIR/.github/hooks/pre-commit" ]; then
    ln -sf "$SCRIPT_DIR/.github/hooks/pre-commit" "$HOOKS_DIR/pre-commit"
    echo -e "${GREEN}✓ Pre-commit hook installed${NC}"
else
    echo -e "${YELLOW}⚠ Pre-commit hook not found${NC}"
fi

echo -e "${GREEN}Git hooks setup complete!${NC}"
echo -e "${YELLOW}The pre-commit hook will prevent accidental commits of:${NC}"
echo "  - GitHub tokens (ghp_*, github_pat_*, ghs_*)"
echo "  - Private keys"
echo "  - AWS access keys"
echo "  - OpenAI API keys"
echo "  - Files named: secrets.zsh, .env, .envrc"