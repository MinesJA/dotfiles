# Neovim Ruby Auto-Setup TODO

## Goal
Automatically run `setup_ruby_project` when opening Ruby projects in Neovim to ensure correct Ruby version and ruby-lsp are available.

## Option 1: AutoCommand Detection (Recommended)

Add to `/Users/jonathan.mines/dotfiles/.config/nvim/lua/jonathanmines/init.lua`:

```lua
-- Auto-setup Ruby projects
autocmd({'BufRead', 'BufNewFile'}, {
    group = JonathanMinesGroup,
    pattern = '*.rb',
    callback = function()
        -- Check if we're in a Ruby project (has .ruby-version)
        local ruby_version_file = vim.fn.findfile('.ruby-version', '.;')
        if ruby_version_file ~= '' then
            -- Run setup_ruby_project in background
            vim.fn.jobstart({'zsh', '-c', 'source ~/.zshrc && setup_ruby_project'}, {
                cwd = vim.fn.fnamemodify(ruby_version_file, ':h'),
                on_exit = function(_, exit_code)
                    if exit_code == 0 then
                        vim.notify('Ruby project setup complete!', vim.log.levels.INFO)
                        -- Restart ruby-lsp if it's running
                        vim.defer_fn(function()
                            vim.cmd('LspRestart ruby_lsp')
                        end, 1000)
                    else
                        vim.notify('Ruby project setup failed', vim.log.levels.WARN)
                    end
                end,
                stdout_buffered = true,
                stderr_buffered = true,
            })
        end
    end
})
```

## Option 2: Enhanced Shell Function

Modify `setup_ruby_project` in `~/.zshrc` to support silent mode:

```bash
setup_ruby_project() {
    local silent_mode=false
    if [[ "$1" == "--silent" ]]; then
        silent_mode=true
        shift
    fi
    
    local ruby_version=$(cat .ruby-version 2>/dev/null)
    
    if [ -z "$ruby_version" ]; then
        [[ "$silent_mode" != true ]] && echo "No .ruby-version file found"
        return 1
    fi
    
    [[ "$silent_mode" != true ]] && echo "Installing Ruby $ruby_version..."
    rbenv install "$ruby_version" --skip-existing >/dev/null 2>&1
    
    [[ "$silent_mode" != true ]] && echo "Setting local Ruby version..."
    rbenv local "$ruby_version"
    
    [[ "$silent_mode" != true ]] && echo "Installing ruby-lsp..."
    gem install ruby-lsp >/dev/null 2>&1
    
    [[ "$silent_mode" != true ]] && echo "Rehashing rbenv..."
    rbenv rehash
    
    [[ "$silent_mode" != true ]] && echo "✅ Setup complete! Ruby $ruby_version with ruby-lsp is ready."
    return 0
}
```

## Option 3: Manual Command

Add user command to init.lua:

```lua
-- Manual Ruby setup command
vim.api.nvim_create_user_command('RubySetup', function()
    local ruby_version_file = vim.fn.findfile('.ruby-version', '.;')
    if ruby_version_file == '' then
        vim.notify('No .ruby-version file found in project', vim.log.levels.ERROR)
        return
    end
    
    vim.notify('Setting up Ruby project...', vim.log.levels.INFO)
    vim.fn.jobstart({'zsh', '-c', 'source ~/.zshrc && setup_ruby_project --silent'}, {
        cwd = vim.fn.fnamemodify(ruby_version_file, ':h'),
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.notify('Ruby setup complete! Restarting LSP...', vim.log.levels.INFO)
                vim.cmd('LspRestart ruby_lsp')
            else
                vim.notify('Ruby setup failed', vim.log.levels.ERROR)
            end
        end,
    })
end, { desc = 'Setup Ruby project with correct version and ruby-lsp' })
```

## Option 4: Project-based .nvimrc

Alternative: Create `.nvimrc` in each Ruby project:

```lua
-- .nvimrc in Ruby project root
vim.fn.jobstart({'zsh', '-c', 'source ~/.zshrc && setup_ruby_project --silent'})
```

Then add to your main init.lua:
```lua
-- Enable project-local .nvimrc files
vim.opt.exrc = true
vim.opt.secure = true  -- Security for untrusted .nvimrc files
```

## Implementation Notes

- **Option 1** is recommended as it's automatic and doesn't require per-project setup
- The `findfile('.ruby-version', '.;')` searches up the directory tree
- `LspRestart ruby_lsp` ensures the LSP picks up the new Ruby version
- Silent mode prevents terminal spam when running from Neovim
- Consider adding a debounce mechanism if opening many Ruby files quickly

## Current Ruby LSP Config Location

Ruby LSP is already configured in:
`/Users/jonathan.mines/dotfiles/.config/nvim/lua/jonathanmines/lazy/lsp.lua` (lines 62-69)

The config already uses rbenv shims: `~/.rbenv/shims/ruby-lsp`