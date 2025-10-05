# Repository Guidelines

## Project Structure & Module Organization
This repository captures personal dotfiles. Root-level scripts such as `install` and `alias` wire shell behaviour, while `zshrc` seeds a default shell profile. Editor customisations live under `nvim/`, with `init.lua` bootstrapping modules inside `lua/user/` (keymaps, options, plugins, resize helpers) and `colors/` providing scheme overrides. Terminal tweaks reside in `tmux/` (notably `tmux.conf` and the helper command `t`). Shared lint configuration sits in `luacheckrc`, and the Codex agent settings ship through `codex/config.toml`.

## Build, Test, and Development Commands
- `chmod +x install && ./install`: Symlink or copy configs into `~`, regenerating Neovim, tmux, alias, and Codex state.
- `tic -x tmux/tmux-256color.terminfo`: Register the included terminfo to unlock italics in tmux.
- `nvim --headless '+Lazy sync' +qa`: Refresh Lazy-managed plugins after adding or removing files under `nvim/lua/user/plugins/`.

## Coding Style & Naming Conventions
Lua sources use two-space indentation, lowercase snake_case filenames, and prefer module-scoped tables over globals. Format Lua with `stylua nvim` before committing; when adding new style rules, update `stylua.toml` if introduced. Lint with `luacheck nvim/lua` so that `luacheckrc` guards against undefined globals. Shell snippets stay POSIX-compliant (`#!/usr/bin/env sh`), and tmux scripts should mimic the succinct option-setting style already present.

## Testing Guidelines
Run `luacheck nvim/lua` to catch regressions in Lua helpers. Launch `nvim --headless '+checkhealth' +qa` after plugin or LSP changes to confirm dependencies resolve. Exercise the `install` script inside a disposable user profile to verify links land in `~/.config`, `~/.local/bin`, and `~/.codex/` as expected.

## Commit & Pull Request Guidelines
Commits follow short, imperative messages (e.g., `add codex config`) without trailing punctuation; group related edits so diffs stay atomic. Pull requests should outline high-level intent, list any manual steps (such as rerunning `install`), and mention verification commands executed. Include screenshots or terminal captures only when visual changes occur (for instance, new tmux colours).

## Environment & Tooling Notes
Homebrew remains the primary installer for dependencies (Neovim, tmux, mysql-client, language runtimes); align versions with the README. Ensure Operator Mono and Hack Nerd Font are configured in iTerm2 before sharing theme changes. Mason manages language servers inside Neovim—note new tooling in documentation and confirm corresponding binaries are available via `brew`, `pyenv`, or `rbenv` as outlined.
