# dotfiles

Portable shell environment and tool configuration for Unix systems (Linux & macOS).
Manages dotfiles, shell aliases, functions, and system-specific settings across multiple machines.

## Quick Start

```bash
git clone <repo> ~/env
cd ~/env
./install.sh
```

This will:
- Link shell configs (`~/.zshrc`, `~/.bashrc`, `~/.profile`)
- Install bin scripts to PATH
- Apply OS-specific setup (XDG dirs on Linux, VSCode paths on both)
- Symlink config files from `dotfiles/config/*` to `~/.config/` (or `~/Library/Application Support/` on macOS)
- Setup Oh My Zsh if available

## Structure

```
bin/              # Executable scripts added to PATH (install-*, convert-*, etc.)
dotfiles/         # Home directory configs
  config/         # XDG config files symlinked to ~/.config
  local/          # User-local data (icons, fonts, applications)
  systemd/        # Systemd user services
  profile         # Shell environment (sourced by all shells)
  zshrc           # Zsh config
  bashrc          # Bash config
  gitconfig       # Git config
scripts/          # Shell functions and aliases
  aliases.sh      # General aliases
  aliases-k8s.sh  # Kubernetes aliases
  aliases-docker.sh
  functions.sh    # Shell functions (includes install_link utility)
hosts/            # Hostname-specific configs
  <hostname>/
    bin/          # Host-specific scripts
    profile       # Host-specific env vars
etc/              # System-level configs (libinput, etc.)
env.sh            # Environment initialization (sources everything)
install.sh        # Setup script
```

## Environment

`env.sh` is sourced by login shells and sets up:
- `$ENV_HOME` — repo root directory
- `$PATH` — includes `bin/` and host-specific `bin/`
- Global aliases and functions from `scripts/`
- Host-specific profile if available

Host detection is automatic via `hostname`. Create `hosts/<hostname>/profile` for machine-specific overrides.

## Tracking New Configs

Use `dotfiles-track-config` to add a new config folder to version control:

```bash
dotfiles-track-config ~/.config/nvim
dotfiles-track-config ~/.ssh
dotfiles-track-config ~/.mytool
```

This will:
1. Move the folder into `dotfiles/config/<name>`
2. Create a symlink from the original location back to the repo
3. Print the git command to commit it

Then run `./install.sh` on other machines to recreate the symlinks.

## Shell Initialization

- **Login shells** (zsh, bash): source `~/.profile` → `env.sh` → all aliases/functions
- **Interactive shells**: source `~/.zshrc` or `~/.bashrc` → includes NVM, GPG, custom PATH

Environment variables for LLM tools and work-related settings (GOPRIVATE, etc.) are set in `dotfiles/profile`.

## OS-Specific Setup

**Linux:**
- Creates `~/.local/share/{icons,fonts}`
- Configures XDG user directories
- Manages immutable attributes on `user-dirs.dirs` to prevent accidental edits
- Links VSCode settings to `~/.config/Code/User/`

**macOS:**
- Links VSCode settings to `~/Library/Application Support/Code/User/`
- Uses macOS-appropriate config directories

## Adding Tools

Place executable shell scripts or binaries in `bin/` to make them available system-wide.
Run `./install.sh` to add them to `$PATH`.

## Customization

Create `hosts/<your-hostname>/profile` for machine-specific settings:
- Custom `$PATH` entries
- Environment overrides
- Local aliases

To find your hostname:
```bash
hostname
```

---

These are personal dotfiles provided as-is. Feel free to adapt the structure for your own setup.
