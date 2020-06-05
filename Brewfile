# Allow things from homebrew core or casks
tap "homebrew/cask"
cask_args appdir: "/Applications"

# User software
cask "chromium"

# Language ecosystems:
brew "node@12", link: true
brew "node", link: false
brew "python"
brew "pyenv"
brew "lua"
brew "cocoapods" # XCode package manager
brew "watchman" # For fb react tools
brew "postgres"
brew "shellcheck"
brew "yarn"

# Standard util polyfills for mac:
brew "gnupg"
brew "libpng"

# Better Utils:
brew "neovim"
brew "ripgrep"
brew "fd"
brew "jq"
brew "tig"
brew "fzf"
brew "bat"
brew "git-delta"

# Service CLIs:
brew "gh" # GitHub new
brew "hub" # GitHub legacy
brew "awscli" # AWS
brew "docker-credential-helper-ecr" # Docker creds helper; make sure to update ~/.docker/config.json

# Pilot deps:
cask "1password-cli"
brew "openssl@1.1"
brew "pinentry-mac"
brew "terraform"
