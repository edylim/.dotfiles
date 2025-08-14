# My Dotfiles

These are my personal dotfiles for setting up a development environment on macOS and Linux. The setup is automated with a comprehensive installation script.

## Installation

To install these dotfiles, clone the repository and run the `install.sh` script:

```bash
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installation script will:

- Detect the operating system (macOS or Linux).
- Install Homebrew (if on macOS and not already installed).
- Install a list of core packages and applications.
- Install shell frameworks (`prezto` for Zsh and `tpm` for Tmux).
- Install the [GrumpyVim](https://github.com/edylim/grumpy-vim) Neovim configuration.
- Back up any existing dotfiles in your home directory.
- Symlink the dotfiles from this repository to your home directory using `stow`.
- Set Zsh as the default shell.

## Configured Applications

This setup includes configurations for the following applications:

- **Shell:** Zsh with Prezto
- **Terminal:** Kitty
- **Multiplexer:** Tmux with TPM
- **Editor:** Neovim (via GrumpyVim)
- **Git:** Basic git configuration with support for a local private config.
- **Other Tools:**
    - `awrit`: A custom application.
    - `yazi`: A file manager.
    - `asdf`: A version manager.
    - `zoxide`: A smarter `cd` command.

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
