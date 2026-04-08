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
os/               # OS/distro-specific overlays
  linux/          # Generic Linux profile/bin (always loaded on Linux)
  macos/          # macOS profile/bin
  ubuntu/         # Ubuntu-specific overrides
  archlinux/      # Arch-specific overrides
  gentoo/         # Gentoo-specific overrides
etc/              # System-level configs (libinput, etc.)
env.sh            # Environment initialization (sources everything)
install.sh        # Setup script
```

## Environment

`env.sh` is sourced by login shells and sets up:
- `$ENV_HOME` — repo root directory
- `$PATH` — includes `bin/` and OS/distro-specific `bin/`
- Global aliases and functions from `scripts/`
- OS/distro profile overlays if available
- `$ENV_OS` / `$ENV_DISTRO` — resolved runtime platform values

OS and distro detection is automatic via `$OSTYPE` and `/etc/os-release`.
Load order:
1. `os/macos/profile` on macOS, or
2. `os/linux/profile` on Linux, then `os/<distro>/profile` if present.

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

## Validation & Preview

Preview changes without applying them:

```bash
./install.sh --dry-run
```

Validate links and dependencies:

```bash
dotfiles-doctor
dotfiles-doctor --fix
```

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

Create OS/distro profiles for machine-family settings:
- `os/linux/profile` for generic Linux exports/aliases
- `os/macos/profile` for macOS-specific exports/aliases
- `os/<distro>/profile` for distro-specific overrides (Ubuntu/Arch/Gentoo)

To find your distro ID used by `env.sh`:
```bash
grep '^ID=' /etc/os-release
```

---

These are personal dotfiles provided as-is. Feel free to adapt the structure for your own setup.
