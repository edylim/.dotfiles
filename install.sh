#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Global Variables ---
AUTO_INSTALL_ALL=false

# --- Helper Functions for Logging ---
info() {
  echo "[INFO] $1"
}

success() {
  echo "✅ [SUCCESS] $1"
}

error() {
  echo "❌ [ERROR] $1"
  exit 1
}

warn() {
  echo "⚠️ [WARNING] $1"
}

prompt_user() {
  local question=$1
  if [ "$AUTO_INSTALL_ALL" = true ]; then
    return 0
  fi

  read -p "$question [Y]es/[n]o/[a]ll? " choice
  case "$choice" in
    a|A ) AUTO_INSTALL_ALL=true; return 0;; 
    y|Y|"" ) return 0;; 
    n|N ) return 1;; 
    * ) echo "Invalid input. Please enter y, n, or a."; prompt_user "$question";;
  esac
}

# --- OS Detection ---
OS=""
PKG_MANAGER=""

detect_os() {
  if [[ "$(uname)" == "Darwin" ]]; then
    OS="macos"
  elif [[ "$(uname)" == "Linux" ]]; then
    OS="linux"
  else
    error "Unsupported OS. This script is for macOS and Linux only."
  fi
  info "Running on $OS..."
}

# --- Package Manager Setup ---
install_package_manager() {
  info "Setting up package manager..."
  if [[ "$OS" == "macos" ]]; then
    if ! command -v brew &> /dev/null; then
      info "Homebrew not found. Installing..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      success "Homebrew installed."
    else
      success "Homebrew is already installed."
    fi
    info "Updating Homebrew..."
    brew update
  elif [[ "$OS" == "linux" ]]; then
    if command -v apt-get &> /dev/null; then
      PKG_MANAGER="apt"
      info "APT detected. Updating package lists..."
      sudo apt-get update
    elif command -v dnf &> /dev/null; then
      PKG_MANAGER="dnf"
      info "DNF detected."
    else
      error "Could not find APT or DNF. Your Linux distribution is not supported."
    fi
  fi
}

# --- Application Installation ---
install_core_packages() {
  info "Installing core packages..."
  if [[ "$OS" == "macos" ]]; then
    info "Installing packages from Brewfile..."
    if ! brew bundle --file="$HOME/.dotfiles/homebrew/Brewfile"; then
      error "Failed to install packages from Brewfile."
    fi
  elif [[ "$OS" == "linux" ]]; then
    local PACKAGES_LINUX=("git" "stow" "zsh" "neovim" "tmux" "fzf" "bat" "htop" "gh" "jq" "tree" "wget" "zoxide" "lazygit" "ripgrep" "fd-find" "build-essential" "ffmpeg" "p7zip-full" "unzip" "poppler-utils" "librsvg2-bin" "imagemagick" "kitty" "nodejs")
    info "Installing packages: ${PACKAGES_LINUX[*]}"
    sudo $PKG_MANAGER install -y "${PACKAGES_LINUX[@]}"
  fi
  success "Core packages installed."
}

install_npm_tools() {
  info "Installing global npm packages..."
  local NPM_PACKAGES=("eslint@latest" "prettier@latest" "eslint-config-airbnb-base@latest" "eslint-plugin-import@latest" "eslint-config-prettier@latest")
  if [[ "$OS" == "linux" ]]; then
    NPM_PACKAGES+=("@google/gemini-cli@latest")
  fi
  sudo npm install -g "${NPM_PACKAGES[@]}"
  success "Global npm packages installed."
}

install_awrit() {
    info "Installing Awrit..."
    local AW_INSTALL_DIR="$HOME/.awrit"

    if [ ! -f "$AW_INSTALL_DIR/awrit" ]; then
        info "Downloading Awrit to $AW_INSTALL_DIR..."
        curl -fsS https://chase.github.io/awrit/get | DOWNLOAD_TO="$AW_INSTALL_DIR" bash
        success "Awrit downloaded."
    else
        success "Awrit appears to be already installed at $AW_INSTALL_DIR."
    fi

    info "Stowing awrit configuration..."
    # Remove the default kitty.css if it exists, so stow can create a symlink
    if [ -f "$AW_INSTALL_DIR/dist/kitty.css" ]; then
        rm "$AW_INSTALL_DIR/dist/kitty.css"
    fi
    cd ~/.dotfiles
    stow -R awrit
    cd - > /dev/null
    success "Awrit configuration stowed."
}

install_yazi() {
    info "Installing Yazi..."
    if command -v yazi &> /dev/null; then
        success "Yazi is already installed."
        return
    fi

    if [[ "$OS" == "linux" ]]; then
        if [[ "$PKG_MANAGER" == "dnf" ]]; then
            info "Enabling COPR repository for Yazi..."
            sudo dnf install -y dnf-plugins-core
            sudo dnf copr enable -y lihaohong/yazi
            sudo dnf install -y yazi
        elif [[ "$PKG_MANAGER" == "apt" ]]; then
            info "Downloading latest Yazi binary for Debian/Ubuntu..."
            local YAZI_URL=$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | jq -r '.assets[] | select(.name | contains("x86_64-unknown-linux-musl.zip")) | .browser_download_url')
            local TEMP_DIR=$(mktemp -d)
            curl -L "$YAZI_URL" -o "$TEMP_DIR/yazi.zip"
            unzip "$TEMP_DIR/yazi.zip" -d "$TEMP_DIR"
            sudo mv "$TEMP_DIR/yazi" /usr/local/bin/
            sudo mv "$TEMP_DIR/ya" /usr/local/bin/
            rm -rf "$TEMP_DIR"
        fi
    fi
    success "Yazi installed."
}

install_shell_frameworks() {
  info "Installing shell frameworks..."
  if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
    info "Installing Prezto..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  else
    success "Prezto already installed."
  fi

  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM for Tmux..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    success "TPM already installed."
  fi
}

install_grumpyvim() {
  info "Installing GrumpyVim (Neovim config)..."
  local NVIM_CONFIG_DIR="$HOME/.config/nvim"

  if [ -d "$NVIM_CONFIG_DIR" ]; then
    warn "Existing Neovim configuration found at $NVIM_CONFIG_DIR."
    if prompt_user "Back it up and proceed?"; then
      local BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%F-%T)"
      info "Backing up existing config to $BACKUP_DIR"
      mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    else
      info "GrumpyVim installation cancelled."
      return
    fi
  fi

  info "Cloning GrumpyVim repository..."
  git clone https://github.com/edylim/grumpy-vim.git "$NVIM_CONFIG_DIR"
  success "GrumpyVim installed."
}

# --- Configuration ---
stow_dotfiles() {
  info "Linking configuration files with Stow..."
  local PACKAGES=("git" "zsh" "kitty" "tmux" "yazi" "linting")
  cd ~/.dotfiles
  for pkg in "${PACKAGES[@]}"; do
    info "Stowing $pkg..."
    stow -R "$pkg"
  done
  cd - > /dev/null
  success "All packages have been stowed."
}

set_zsh_default() {
  info "Setting Zsh as the default shell..."
  local ZSH_PATH=$(which zsh)
  if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    success "Zsh is already the default shell."
    return
  fi
  if sudo chsh -s "$ZSH_PATH" "$(whoami)"; then
    success "Default shell changed to Zsh. Please log out and log back in."
  else
    error "Could not set Zsh as default shell. Please do it manually."
  fi
}

display_summary() {
  local message="This script will set up your development environment. Here is a summary of what will be installed and configured:\n\n"
  message+="--- Core CLI Packages ---\n"
  message+="  - git: A distributed version control system (https://git-scm.com/)\n"
  message+="  - stow: A symlink farm manager for managing dotfiles (https://www.gnu.org/software/stow/)\n"
  message+="  - zsh: A powerful shell with advanced features (https://www.zsh.org/)\n"
  message+="  - neovim: A modern, highly extensible, and customizable text editor (https://neovim.io/)\n"
  message+="  - tmux: A terminal multiplexer to manage multiple terminal sessions (https://github.com/tmux/tmux/wiki)\n"
  message+="  - fzf: A command-line fuzzy finder (https://github.com/junegunn/fzf)\n"
  message+="  - bat: A cat(1) clone with syntax highlighting (https://github.com/sharkdp/bat)\n"
  message+="  - htop: An interactive process viewer (https://htop.dev/)\n"
  message+="  - gh: GitHub's official command-line tool (https://cli.github.com/)\n"
  message+="  - jq: A command-line JSON processor (https://stedolan.github.io/jq/)\n"
  message+="  - tree: A recursive directory listing program (https://gitlab.com/OldManProgrammer/unix-tree)\n"
  message+="  - wget: A utility for non-interactive download of files from the Web (https://www.gnu.org/software/wget/)\n"
  message+="  - mas: A command-line interface for the Mac App Store (https://github.com/mas-cli/mas)\n"
  message+="  - zoxide: A smarter cd command that learns your habits (https://github.com/ajeetdsouza/zoxide)\n"
  message+="  - lazygit: A simple terminal UI for git commands (https://github.com/jesseduffield/lazygit)\n"
  message+="  - ripgrep: A line-oriented search tool (https://github.com/BurntSushi/ripgrep)\n"
  message+="  - fd: A simple and fast alternative to 'find' (https://github.com/sharkdp/fd)\n"
  message+="  - ffmpeg: A complete, cross-platform solution to record, convert and stream audio and video (https://ffmpeg.org/)\n"
  message+="  - sevenzip: A file archiver with a high compression ratio (https://www.7-zip.org/)\n"
  message+="  - poppler: A PDF rendering library and command-line tools (https://poppler.freedesktop.org/)\n"
  message+="  - resvg: An SVG rendering library (https://github.com/RazrFalcon/resvg)\n"
  message+="  - imagemagick: A software suite to create, edit, compose, or convert bitmap images (https://imagemagick.org/)\n"
  message+="  - kitty: A fast, feature-rich, GPU-based terminal emulator (https://sw.kovidgoyal.net/kitty/)\n"
  message+="  - font-symbols-only-nerd-font: A font patched with a high number of glyphs and icons (https://www.nerdfonts.com/)\n"
  message+="  - build-essential: (Linux only) Installs tools for compiling software from source.\n"
  message+="  - unzip: (Linux only) A utility for extracting ZIP archives.\n\n"
  message+="--- JavaScript Development Tools ---\n"
  message+="  - Node.js: A JavaScript runtime built on Chrome's V8 JavaScript engine.\n"
  message+="  - ESLint: A tool for identifying and reporting on patterns found in ECMAScript/JavaScript code.\n"
  message+="  - Prettier: An opinionated code formatter.\n\n"
  message+="--- Custom Applications and Configurations ---\n"
  message+="  - Gemini CLI: A command-line interface for Google's Gemini model.\n"
  message+="  - Awrit: A custom browser-like application (https://github.com/chase/awrit)\n"
  message+="  - Yazi: A terminal file manager (https://github.com/sxyazi/yazi)\n"
  message+="  - Prezto: A configuration framework for Zsh (https://github.com/sorin-ionescu/prezto)\n"
  message+="  - TPM (Tmux Plugin Manager): A plugin manager for tmux (https://github.com/tmux-plugins/tpm)\n"
  message+="  - GrumpyVim: A Neovim configuration (https://github.com/edylim/grumpy-vim)\n\n"
  message+="--- Configuration Steps ---\n"
  message+="  - Link the new dotfiles using stow.\n"
  message+="  - Set Zsh as the default shell.\n"
  message+="\nNOTE: This script will require sudo access and may prompt for your password to install system-wide packages and change the default shell.\n"

  echo -e "$message"
}


# --- Main Execution ---
main() {
  detect_os
  display_summary
  if ! prompt_user "Proceed with the installation?"; then
    info "Installation cancelled."
    exit 0
  fi

  install_package_manager
  install_core_packages
  install_npm_tools
  install_awrit
  install_yazi
  install_shell_frameworks
  install_grumpyvim
  stow_dotfiles
  set_zsh_default

  success "🎉 All done! Your new system is ready to go."
  info "Remember to log out and log back in for all changes to take effect."
}

# Run the main function
main
