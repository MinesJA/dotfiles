## How to add Github MCP

# Adds Github MCP server to the User (global) scope
```
claude mcp add github -s user -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_MCP_TOKEN -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN "ghcr.io/github/github-mcp-server"
```

Where does this actually get saved though? I can't figure out where this is actually persisted. If I add an mcp.json to .claude it just scopes it to the project not globally.

## Github Actions
[Claude Docs](https://docs.anthropic.com/en/docs/claude-code/github-actions)

Looks interesting but it looks like you get charged per usage and is not associated with your Claude sub.
