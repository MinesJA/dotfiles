#!/bin/bash

# Create local fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Copy fonts from dotfiles to system
cp ~/.config/fonts/*.ttf ~/.local/share/fonts/
cp ~/.config/fonts/*.otf ~/.local/share/fonts/ 2>/dev/null

# Update font cache
fc-cache -fv

echo "Fonts installed successfully!"
