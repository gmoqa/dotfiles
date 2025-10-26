# Dotfiles - Managed with GNU Stow

Configuration files for Termux/Linux managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 Structure

Each directory is a "package" that can be independently installed:

```
dotfiles/
├── bash/       # Shell configuration (.bashrc, .bash_aliases)
├── zsh/        # Zsh + Oh My Zsh + fzf configuration
├── ssh/        # SSH client config (NO private keys!)
└── termux/     # Termux-specific settings
```

## 🚀 Usage

### Install all packages
```bash
cd ~/dotfiles
stow */
```

### Install specific package
```bash
cd ~/dotfiles
stow bash      # Creates ~/.bashrc and ~/.bash_aliases
stow zsh       # Creates ~/.zshrc (requires oh-my-zsh)
stow ssh       # Creates ~/.ssh/config
stow termux    # Creates ~/.termux/
```

### Uninstall a package
```bash
cd ~/dotfiles
stow -D bash   # Removes symlinks for bash package
```

### Re-stow (useful after pulling changes)
```bash
cd ~/dotfiles
stow -R bash   # Remove and reinstall bash package
```

## 🔄 Setup on new machine

### Basic Setup
```bash
# Clone your dotfiles
git clone git@github.com:gmoqa/dotfiles.git ~/dotfiles

# Install stow (if needed)
pkg install stow

# Install packages
cd ~/dotfiles
stow bash ssh termux

# Source bash config
source ~/.bashrc
```

### Zsh Setup (Optional but Recommended)
```bash
# Install zsh and fzf
pkg install zsh fzf

# Install oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

# Stow zsh config
cd ~/dotfiles
stow zsh

# Change default shell to zsh
chsh -s zsh

# Restart terminal or run
zsh
```

## 🔒 Security

- ✅ SSH **config** is versioned
- ❌ SSH **private keys** are NOT versioned (protected by .gitignore)
- ❌ Tokens, passwords, and secrets are excluded

See `.gitignore` for full list of excluded files.

## 📝 Adding new dotfiles

1. Create or move file to appropriate package:
   ```bash
   mkdir -p ~/dotfiles/mypackage
   mv ~/.myconfig ~/dotfiles/mypackage/.myconfig
   ```

2. Stow the package:
   ```bash
   cd ~/dotfiles
   stow mypackage
   ```

3. Commit to git:
   ```bash
   git add mypackage
   git commit -m "Add mypackage configuration"
   ```

## 🎯 Tips

- Use `stow -n <package>` to preview changes without applying (dry-run)
- Use `stow -v <package>` for verbose output
- Package names should match their purpose (vim, git, zsh, etc.)
