# linux-forgeup
> Modular, no‑sudo friendly Debian/Ubuntu bootstrap: local GitHub release installers + optional full system provisioning.

<img src="media/banner.png" alt="forge-up-banner" width="100%">

## ✨ Scenarios

| Scenario | What You Get |
|----------|--------------|
| Fresh machine (sudo access) | Install all you need on a new machine exactly like you are used to on other machines: APT packages, services, dotfiles, modern CLI stack |
| Restricted host (no sudo) | Local `$HOME/.local/bin` installs (fzf, ripgrep, starship, neovim, etc.) |

On many servers (CI runners, shared university hosts, corporate bastions) you lack sudo. Standard package managers become unusable. Forge-Up provides helpers to fetch and unpack release artifacts locally (e.g. `install_starship_prompt`, `install_eza`, `install_ripgrep`) so you still get modern tooling.

## 🧩 Key Features

- APT install batch via `install_apt_packages`
- Local (no sudo) GitHub release installers (`install_gh_binary`, `install_gh_package`) plus wrappers:
  starship, eza, fzf, ripgrep (rg), lazygit, lazydocker, navi, neovim, dust, zoxide, rust
- Dotfiles cloning + stowing (GNU Stow)
- Systemd service enabling
- Colored logging + ASCII banner
- Idempotent, re-runnable provisioning

## 🚀 Quick Start (Full Provisioning)

```bash
git clone https://github.com/sascha-kirch/linux-forgeup.git
cd linux-forgeup
chmod +x forgeup
./forgeup -u -a -o -d
```


**Flags:**

- `-u`, `--update-system`: Update and upgrade the system packages with apt. [Requires sudo].
- `-a`, `--apt-packages`: Install APT packages listed in [config/packages.conf](config/packages.conf). [Requires sudo].
- `-o`, `--other-packages`: install other (local) packages
- `-s`, `--enable-services`: Enable and start services listed in [config/services.conf](config/services.conf). [Requires sudo].
- `-d`, `--setup-dotfiles`: Setup and stow dotfiles listed in [config/dotfiles.conf](config/dotfiles.conf) from [sascha-kirch/dotfiles](https://github.com/sascha-kirch/dotfiles).
- `-h`, `--help`: Display help message.


No-sudo minimal (only local user installs, no sudo):

```bash
./forgeup -o
```

>[!NOTE]
>Forge-Up auto-disables sudo-required steps if user not in sudo group

## 📁  Structure

```
.
├─ forgeup                 # main executable (flags, orchestration)
├─ forgeup_lib.sh          # aggregator (sources lib/*.sh)
├─ lib/
│  ├─ logging.sh           # print_logo, log_info, log_error, ...
│  ├─ core.sh              # can_sudo, is_installed, file_exists, fatal
│  ├─ gh_install.sh        # install_gh_binary / install_gh_package
│  ├─ installers.sh        # install_starship_prompt, install_nvim, ...
│  ├─ apt.sh               # install_apt_packages
│  ├─ services.sh          # enable_services
│  ├─ vim.sh               # vim-plug + plugins
│  ├─ tmux.sh              # tmux helpers
│  └─ dotfiles.sh          # setup_dotfiles, stow_dotfiles
├─ config/
│  ├─ packages.conf        # APT_PACKAGES array
│  ├─ services.conf        # SERVICES array
│  └─ dotfiles.conf        # DOTFILES_TO_STOW array
├─ VERSION
├─ Makefile
└─ README.md
```


## 🔌 Modular / Manual Usage

Aggregator load (recommended, loads all modules in correct order):

```bash
# from any directory
source /path/to/linux-forgeup/forgeup_lib.sh
print_logo
install_fzf
install_ripgrep 14.1.1
install_starship_prompt v1.23.0
```

Source specific modules (advanced, because dependencies to logging/core exist):

```bash
. lib/logging.sh
. lib/core.sh
. lib/gh_install.sh
install_gh_binary "junegunn/fzf" v0.66.0 "fzf-0.66.0-linux_amd64" true
```

Ensure PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Persist:

```bash
grep -q '.local/bin' ~/.profile || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
```

## 🙌 Install Wrapper

Use wrappers for common tools in [lib/installers.sh](lib/installers.sh):

```bash
source /path/to/linux-forgeup/forgeup_lib.sh
# GitHub release installers with defaults:
install_starship_prompt
install_eza
install_navi
install_fzf
install_ripgrep
install_dust
install_lazygit
install_nvim

# Other installers wrapping custom logic:
install_rust
uninstall_rust
install_lazydocker
install_zoxide
install_ollama
install_claude
install_uv
```

GitHub install wrappers accept optional version argument:

```bash
install_nvim v0.11.4
install_lazygit v0.55.1
install_fzf v0.66.0
```

> [!TIP]
> If version omitted the default inside [lib/installers.sh](lib/installers.sh) is used.

Local Install Logic:

- Binaries go to: `$HOME/.local/bin/<name>`
- Packages go to: `$HOME/.local/packages/<repo_subname>` then symlinked into `$HOME/.local/bin`
- Uses GitHub release tarballs: `install_gh_binary` (direct binary), `install_gh_package` (extract + symlink)
- Safe reinstallation via passing `true` internally (see wrappers)

## 📦 APT Packages

Edit [config/packages.conf](config/packages.conf):

```bash
APT_PACKAGES=(
  htop
  stow
  tmux
  git
)
```

Run:

```bash
./forgeup -a
```

> [!WARNING]
> Requires sudo.

## 🔧 Dotfiles

Configure sets in [config/dotfiles.conf](config/dotfiles.conf):

```bash
DOTFILES_TO_STOW=(tmux vim bash starship)
```

Run:

```bash
./forgeup -d
```

Manual:

```bash
source forgeup_lib.sh
setup_dotfiles
stow_dotfiles tmux vim
```

> [!NOTE]
> For now it clones my own [sascha-kirch/dotfiles](https://github.com/sascha-kirch/dotfiles) repository for setting up dotfiles. You can modify `setup_dotfiles` in [lib/dotfiles.sh](lib/dotfiles.sh) to use your own repo.

## 👻 Services

Add service names to [config/services.conf](config/services.conf):

```bash
SERVICES=(
  ssh
  cron
)
```

Then run:

```bash
./forgeup -s
```

Manual:

```bash
source forgeup_lib.sh
enable_services ssh cron
```

> [!WARNING]
> Requires sudo.


## 🔍 Logging Example

```
12:34:56 [INFO][FORGE-UP] Installing version 'v1.23.0' of repo 'starship/starship' ...
```

Levels: INFO / WARNING / ERROR / CONFIG

## 🛤 Known Limitations / TODO

- Add checksum verification for downloaded archives.
- Add uninstall functions for each tool.
- Improve version auto-discovery (currently manual defaults).
- Add support for other package managers and and non-systemd services.
- currently only GitHub releases as source for local installs.
- uses my own dotfiles repo; make this configurable.

## 🧯 Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| Tool not found after install | PATH not updated | Add `export PATH="$HOME/.local/bin:$PATH"` to .profile |
| APT steps skipped | No sudo group membership | Run only `-o` (local installs) or gain sudo |
| Neovim old version still used | `/usr/bin/nvim` shadowing | Remove system neovim (handled automatically in `install_nvim`) |

## 📄 Version

Current version: [VERSION](VERSION)

Exported as `FORGEUP_VERSION` when sourcing [forgeup_lib.sh](forgeup_lib.sh)

## 🤝 Contributing

1. Open issue / fork
2. Add/change functions in appropriate `lib/*.sh`
3. Keep wrappers idempotent
4. Run `make lint

---
Happy forging 🔧
