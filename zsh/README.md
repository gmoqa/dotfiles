# Zsh Configuration

Oh My Zsh configuration with useful plugins and fzf integration.

## Features

### Theme
- **agnoster** - Clean, informative prompt with git status

### Plugins
- **git** - Git aliases and helpers
- **fzf** - Fuzzy finder integration
- **z** - Jump to frequently used directories
- **colored-man-pages** - Colorized man pages
- **command-not-found** - Suggest packages for missing commands
- **extract** - Universal archive extractor

### FZF Integration
- Fuzzy file search with `Ctrl+T`
- Fuzzy history search with `Ctrl+R`
- Fuzzy directory navigation with `Alt+C`
- Custom color scheme (dark theme)

### Shared Configuration
- Loads `.bash_aliases` for compatibility
- Shares aliases between bash and zsh
- History settings (10000 entries, deduplication)

## Installation

```bash
# Install dependencies
pkg install zsh fzf

# Install oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

# Stow configuration
cd ~/dotfiles
stow zsh

# Change default shell
chsh -s zsh
```

## FZF Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+T` | Fuzzy file search (paste to command line) |
| `Ctrl+R` | Fuzzy history search |
| `Alt+C` | Fuzzy directory change |

## Notes

- Oh My Zsh installation directory: `~/.oh-my-zsh/`
- This directory is NOT version controlled (too large)
- Only `.zshrc` is managed by dotfiles
