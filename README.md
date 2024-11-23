# Nix System Configuration

A comprehensive Nix configuration for setting up a development environment on macOS. This configuration uses nix-darwin and home-manager to manage system settings, development tools, and application configurations.

## Features

- **System Configuration**
  - macOS system settings optimization
  - App Store integration for installing applications
  - Homebrew integration for managing macOS applications

- **Development Environment**
  - Neovim with modern IDE features
    * LSP support
    * Fuzzy finding (Telescope)
    * File tree (NERDTree)
    * Git integration
    * Multiple language support
  - Tmux configuration
    * Modern theme (Dracula)
    * Session management
    * Custom key bindings
    * Mouse support
  - Zsh configuration with oh-my-zsh

- **Included Software**
  - Development tools: git, gcc, make, cmake
  - Programming languages: Python, Node.js, Go
  - Command line utilities: ripgrep, fd, jq, tree
  - Modern alternatives: bat (cat), exa (ls)
  - Terminal: Alacritty

## Prerequisites

1. Install Xcode Command Line Tools:
```bash
xcode-select --install
```

2. Install Nix:
```bash
sh <(curl -L https://nixos.org/nix/install)
```

3. Install nix-darwin:
```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

4. Install home-manager:
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd nix-os-auto
```

2. Customize the configuration:
   - Edit `home.nix` for user-specific packages
   - Edit `darwin-configuration.nix` for macOS settings
   - Edit `config/nvim.nix` for Neovim configuration
   - Edit `config/tmux.nix` for Tmux configuration

3. Build and activate the configuration:
```bash
# Build the configuration
nix build .#darwinConfigurations.default.system

# Switch to the new configuration
./result/sw/bin/darwin-rebuild switch --flake .
```

## Directory Structure

```
.
├── README.md
├── flake.nix              # Main Nix configuration
├── darwin-configuration.nix # macOS-specific settings
├── home.nix              # Home-manager configuration
└── config/
    ├── nvim.nix         # Neovim configuration
    └── tmux.nix         # Tmux configuration
```

## Customization

### Adding New Packages

To add new packages, edit `home.nix`:
```nix
home.packages = with pkgs; [
  # Add your packages here
  your-package-name
];
```

### Installing Mac App Store Applications

To add Mac App Store applications, edit `darwin-configuration.nix`:
```nix
homebrew.masApps = {
  "App Name" = 123456789;  # Replace with App Store ID
};
```

### Modifying Neovim Configuration

Edit `config/nvim.nix` to:
- Add new plugins
- Change key mappings
- Modify settings
- Add language servers

### Modifying Tmux Configuration

Edit `config/tmux.nix` to:
- Change key bindings
- Add plugins
- Modify theme settings
- Adjust status bar

## Maintenance

### Updating

To update all packages to their latest versions:
```bash
nix flake update
darwin-rebuild switch --flake .
```

### Troubleshooting

If you encounter issues:
1. Check the nix store for errors:
```bash
nix store verify
```

2. Clean up old generations:
```bash
nix-collect-garbage -d
```

3. Rebuild from scratch:
```bash
rm -rf result
nix build .#darwinConfigurations.default.system
./result/sw/bin/darwin-rebuild switch --flake .
```

## Contributing

Feel free to submit issues and enhancement requests!
