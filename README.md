# My Dotfiles

These are my personal dotfiles for setting up a development environment on macOS and Linux. The setup is automated with a comprehensive installation script.

## Installation

To install, fork the repository and run the `install.sh` script (Clone this repo at your own risk. There will be CONSTANT breaking changes...):

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

### Zsh

- **Framework:** [Prezto](https://github.com/sorin-ionescu/prezto)
- **Prompt:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **Version Manager:** [asdf](https://asdf-vm.com/)
- **Directory Navigation:** [zoxide](https://github.com/ajeetdsouza/zoxide)

### Tmux

- **Prefix:** `ctrl+a`
- **Plugin Manager:** [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm)
- **Plugins:**
  - `tmux-resurrect`: Persists tmux environment across system restarts.
  - `vim-tmux-navigator`: Seamless navigation between Vim and tmux panes.
  - `tmux-better-mouse-mode`: Better mouse support.
  - `tmux-gruvbox`: A gruvbox theme.
  - `tmux-spotify`: Displays the current Spotify track.

### Kitty

- The configuration is based on the default `kitty.conf` with custom keybindings for window management.
- A custom `kitty.css` for color mapping is used for the `awrit` application.

### Git

- The configuration is minimal and includes a `.gitconfig.local` for user-specific settings.

### Yazi

- A basic `yazi.toml` configuration is provided for the Yazi file manager.

### Awrit

- A custom browser-like application with specific keybindings.

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
