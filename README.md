# linux-forgeup
Linux System Tool to automate setup and configuration of my debian based linux distros

# Functionality
- Installs packages with apt
- installs custom packages from git repositories (lazydocker, starship, tmux plugins)
- enables and starts services
- clones my dotfiles from [https://github.com/sascha-kirch/dotfiles](https://github.com/sascha-kirch/dotfiles) and stows them

# Installion

1. Clone this repository:
```bash
git clone https://github.com/sascha-kirch/linux-forgeup.git
```

2. Run the setup script:
```bash
./run.sh
```

# Kudos
Big thanks to the following projects for inspiration and code snippets:
- [crucible by typecraft](https://github.com/typecraft-dev/crucible)
