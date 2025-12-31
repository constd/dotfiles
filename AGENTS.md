# AGENTS.md - Dotfiles Management

## Project Overview

This repository manages personal dotfiles for a senior software engineer using GNU Stow for symlink management. The configuration supports fish shell, atuin (shell history), tmux, zellij (terminal multiplexer), and related development tools.

## Repository Structure

```
dotfiles/
├── config/
│   ├── aerospace/
│   │   └── .config/aerospace/
│   │       └── aerospace.toml
│   ├── atuin/
│   │   └── .config/atuin/
│   │       └── config.toml
│   ├── fish/
│   │   └── .config/fish/
│   │       ├── conf.d/
│   │       │   ├── atuin.env.fish
│   │       │   ├── rustup.fish
│   │       │   └── uv.env.fish
│   │       ├── functions/
│   │       │   ├── fish_jj_prompt.fish
│   │       │   ├── fish_user_key_bindings.fish
│   │       │   ├── fish_vcs_prompt.fish
│   │       │   └── ls.fish
│   │       └── config.fish
│   ├── ghostty/
│   │   └── .config/ghostty/
│   │       └── config
│   ├── lazygit/
│   │   └── .config/lazygit/
│   │       └── config.yml
│   ├── starship/
│   │   └── .config/
│   │       └── starship.toml
│   ├── tmux/
│   │   └── .config/tmux/
│   │       ├── tmux.conf
│   │       └── tmux.reset.conf
│   └── zed/
│       └── .config/zed/
│           └── settings.json
├── scripts/
│   └── bootstrap.sh
├── CHANGELOG.md
├── VERSION
└── AGENTS.md
```

## Setup Commands

- Install stow: `sudo apt install stow` (Debian/Ubuntu) or `brew install stow` (macOS)
- Bootstrap new machine: `./scripts/bootstrap.sh`
- Stow all packages: `stow */`
- Stow specific package: `stow fish`
- Unstow package: `stow -D fish`
- Restow (update symlinks): `stow -R fish`
- Dry run: `stow -n -v fish`

## Bootstrap Script Requirements

The `scripts/bootstrap.sh` script must:
1. Detect the operating system (Linux/macOS)
2. Install package manager if needed (Homebrew on macOS)
3. Install required dependencies: fish, atuin, tmux, zellij, stow, git
4. Clone this repository to `~/.dotfiles` if not already present
5. Run `stow */` from the dotfiles directory
6. Set fish as the default shell
7. Initialize atuin
8. Print success message with next steps

```bash
#!/usr/bin/env bash
set -euo pipefail
# Bootstrap script structure expected
```

## Semantic Versioning

This project uses semantic versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Breaking changes to dotfile structure or bootstrap process
- **MINOR**: New tool configurations or features added
- **PATCH**: Bug fixes, minor tweaks, documentation updates

### Version Management
- Current version stored in `VERSION` file at repo root
- Update version: `echo "X.Y.Z" > VERSION`
- Tag releases: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
- Changelog maintained in `CHANGELOG.md` following Keep a Changelog format

## Code Style Guidelines

- Shell scripts: Use `shellcheck` for linting, POSIX-compatible when possible
- Fish configs: Follow fish style guide, use `fish_indent` for formatting
- YAML/TOML: 2-space indentation
- All configs should include comments explaining non-obvious settings
- Sensitive data (API keys, tokens) must NEVER be committed - use environment variables or separate encrypted files

## Testing Instructions

Before committing changes:
1. Run `shellcheck scripts/*.sh` for shell script linting
2. Run `fish_indent --check fish/.config/fish/**/*.fish` for fish formatting
3. Test stow dry-run: `stow -n -v */`
4. On a fresh environment (container/VM), run full bootstrap to verify
5. Verify each tool starts without errors after stowing

```bash
# Quick validation
shellcheck scripts/*.sh
stow -n -v */
fish -c "echo 'fish config valid'"
tmux -f tmux/.tmux.conf start-server \; kill-server
zellij setup --check
```

## Security Considerations

- Never commit secrets, API keys, or tokens
- Use `git-crypt` or similar for any sensitive configuration that must be versioned
- SSH keys and GPG keys should be managed separately, not in this repo
- Review changes to shell initialization files carefully - they execute on every shell start
- Atuin sync tokens should be stored in environment variables, not config files
- File permissions: ensure private configs are not world-readable after stowing

## PR and Commit Guidelines

- Commit format: `<type>(<scope>): <description>`
  - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
  - Scope: tool name (fish, tmux, zellij, atuin, bootstrap)
  - Example: `feat(fish): add kubectl abbreviations`
- Update `CHANGELOG.md` for user-facing changes
- Bump `VERSION` file according to semver rules
- One logical change per commit
- Test on both macOS and Linux when possible

## Package-Specific Notes

### Fish
- Entry point: `fish/.config/fish/config.fish`
- Functions go in `fish/.config/fish/functions/`
- Abbreviations preferred over aliases for better discoverability

### Atuin
- Config: `atuin/.config/atuin/config.toml`
- Sync requires `ATUIN_SESSION` environment variable
- Key bindings configured to not conflict with fish defaults

### Tmux
- Config: `tmux/.tmux.conf`
- Plugin manager: tpm (install with `prefix + I`)
- Prefix key: document any non-default prefix

### Zellij
- Config: `zellij/.config/zellij/config.kdl`
- Layouts in `zellij/.config/zellij/layouts/`
- Can coexist with tmux - choose one per session

## Adding New Tool Configurations

1. Create directory: `mkdir -p <tool>/.config/<tool>/`
2. Add configuration files mirroring home directory structure
3. Test with `stow -n -v <tool>`
4. Update bootstrap script if new dependencies required
5. Add section to this AGENTS.md with tool-specific notes
6. Update CHANGELOG.md and bump VERSION (minor version for new tools)
