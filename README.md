# My Dotfiles

These are my personal dotfiles for setting up a development environment on macOS and Linux. The setup is automated with a comprehensive installation script.

## Installation

To install, fork the repository and run the `install.sh` script (Clone this repo at your own risk. There will be CONSTANT breaking changes...):

```bash
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installation script will present a summary of all the software and configurations it will install and then ask for a single confirmation before proceeding.

## Software Overview

The installation script will install and configure the following software:

### Core CLI Packages

- **git:** A distributed version control system (https://git-scm.com/)
- **stow:** A symlink farm manager for managing dotfiles (https://www.gnu.org/software/stow/)
- **zsh:** A powerful shell with advanced features (https://www.zsh.org/)
- **neovim:** A modern, highly extensible, and customizable text editor (https://neovim.io/)
- **tmux:** A terminal multiplexer to manage multiple terminal sessions (https://github.com/tmux/tmux/wiki)
- **fzf:** A command-line fuzzy finder (https://github.com/junegunn/fzf)
- **bat:** A cat(1) clone with syntax highlighting (https://github.com/sharkdp/bat)
- **htop:** An interactive process viewer (https://htop.dev/)
- **gh:** GitHub's official command-line tool (https://cli.github.com/)
- **jq:** A command-line JSON processor (https://stedolan.github.io/jq/)
- **tree:** A recursive directory listing program (https://gitlab.com/OldManProgrammer/unix-tree)
- **wget:** A utility for non-interactive download of files from the Web (https://www.gnu.org/software/wget/)
- **mas:** A command-line interface for the Mac App Store (https://github.com/mas-cli/mas)
- **zoxide:** A smarter cd command that learns your habits (https://github.com/ajeetdsouza/zoxide)
- **lazygit:** A simple terminal UI for git commands (https://github.com/jesseduffield/lazygit)
- **ripgrep:** A line-oriented search tool (https://github.com/BurntSushi/ripgrep)
- **fd:** A simple and fast alternative to 'find' (https://github.com/sharkdp/fd)
- **ffmpeg:** A complete, cross-platform solution to record, convert and stream audio and video (https://ffmpeg.org/)
- **sevenzip:** A file archiver with a high compression ratio (https://www.7-zip.org/)
- **poppler:** A PDF rendering library and command-line tools (https://poppler.freedesktop.org/)
- **resvg:** An SVG rendering library (https://github.com/RazrFalcon/resvg)
- **imagemagick:** A software suite to create, edit, compose, or convert bitmap images (https://imagemagick.org/)
- **kitty:** A fast, feature-rich, GPU-based terminal emulator (https://sw.kovidgoyal.net/kitty/)
- **font-symbols-only-nerd-font:** A font patched with a high number of glyphs and icons (https://www.nerdfonts.com/)
- **build-essential:** (Linux only) Installs tools for compiling software from source.
- **unzip:** (Linux only) A utility for extracting ZIP archives.

### Custom Applications and Configurations

- **Awrit:** A custom browser-like application (https://github.com/chase/awrit)
- **Yazi:** A terminal file manager (https://github.com/sxyazi/yazi)
- **Prezto:** A configuration framework for Zsh (https://github.com/sorin-ionescu/prezto)
- **TPM (Tmux Plugin Manager):** A plugin manager for tmux (https://github.com/tmux-plugins/tpm)
- **GrumpyVim:** A Neovim configuration (https://github.com/edylim/grumpy-vim)

## Customization

### Local Configuration

This repository follows a convention of using `.local` files for private configuration. This allows you to have personal settings that are not tracked by git. The following files are supported:

- `~/.gitconfig.local`: For private git configuration (e.g., user name and email).
- `~/.tmux.conf.local`: For private tmux configuration.
- `~/.zshrc.local`: For private Zsh configuration.

### Git Configuration

To set up your personal git information, create a `~/.gitconfig.local` file with the following content:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

## Structure

The dotfiles are organized by application. The `stow` command is used to create symlinks from the files in this repository to your home directory. For example, the contents of the `zsh` directory will be symlinked to `~/.zshrc`, `~/.zprofile`, etc.