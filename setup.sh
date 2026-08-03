#!/usr/bin/env bash
#
# setup.sh -- install doom-emacs and this configuration on Ubuntu/Debian.
#
# Designed to be called as a module from a parent provisioning script
# (e.g. setup-linux-server.sh), or run directly. Idempotent: re-running it
# is safe and will not duplicate apt packages, clones, or ~/.bashrc lines.
#
# Requires sudo for the apt step only. Everything else is per-user.
#
#   ./setup.sh                            # install, typical-config.el profile
#   ./setup.sh --config base-config.el    # install with a specific profile
#   ./setup.sh --check                    # report what would change, touch nothing
#
# Profiles (see config.el): base-config.el is the portable editor core,
# typical-config.el adds python/julia/claude-code (the default), and
# full-config.el adds the bibtex/citar stack.
#
# Overridable via environment:
#   EMACS_PKG     apt package for emacs        (default: emacs-nox)
#   DOOMDIR       config location              (default: ~/.config/doom)
#   EMACSDIR      doom core location           (default: ~/.config/emacs)
#   CONFIG_REPO   this repo's clone URL        (default: git@github.com:...)
#   SKIP_APT      set to 1 to skip the apt step entirely
#
set -euo pipefail

EMACS_PKG="${EMACS_PKG:-emacs-nox}"
DOOMDIR="${DOOMDIR:-$HOME/.config/doom}"
EMACSDIR="${EMACSDIR:-$HOME/.config/emacs}"
CONFIG_REPO="${CONFIG_REPO:-git@github.com:prairie-guy/doom-emacs_dot_file.git}"
CONFIG_REPO_HTTPS="https://github.com/prairie-guy/doom-emacs_dot_file.git"
DOOM_CORE_REPO="https://github.com/doomemacs/core"
BASHRC="$HOME/.bashrc"
SKIP_APT="${SKIP_APT:-0}"
CHECK_ONLY=0

APT_PACKAGES=(
  git
  ripgrep            # :completion vertico, projectile
  fd-find            # ditto; installs as `fdfind`, doom checks both names
  aspell             # :checkers (spell +aspell)
  aspell-en          # ...which is useless without a dictionary
  pandoc             # :lang (org +pandoc) and markdown export/preview
  build-essential    # gcc/g++/make: compiles vterm and tree-sitter grammars
  libvterm-dev       # :term vterm -- all three of libvterm-dev, pkg-config
  pkg-config         # and libtool-bin are required; see the vterm notes in
  cmake              # the README for why each one matters
  libtool-bin
)

# Deliberately NOT installed here:
#   nodejs/npm  -- comes from the parent setup-linux-server.sh full package set
#   texlive     -- :lang latex works without it until you actually export
#   julia       -- install via juliaup, not apt; apt's version lags badly
#   claude CLI  -- curl -fsSL https://claude.ai/install.sh | bash

CONFIG_PROFILE=""

while (( $# )); do
  case "$1" in
    --check)  CHECK_ONLY=1; shift ;;
    --config) [[ -n "${2:-}" ]] || { printf 'xx --config needs a filename\n' >&2; exit 1; }
              CONFIG_PROFILE="$2"; shift 2 ;;
    --config=*) CONFIG_PROFILE="${1#*=}"; shift ;;
    -h|--help) sed -n '2,20p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) printf 'xx unknown argument: %s (try --help)\n' "$1" >&2; exit 1 ;;
  esac
done

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
skip() { printf '    \033[2m--  %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

# Under --check, describe the action instead of doing it.
run() {
  if (( CHECK_ONLY )); then
    printf '    \033[2m[would run]\033[0m %s\n' "$*"
  else
    "$@"
  fi
}

# ---------------------------------------------------------------- preflight --

[[ "$(uname -s)" == "Linux" ]] || die "this script targets Linux; see README for OSX"

# Doom prefers a legacy ~/.emacs.d over ~/.config/emacs and will silently fail
# to load if a stray one exists. Catch it before we install anything.
if [[ -e "$HOME/.emacs.d" ]]; then
  die "~/.emacs.d exists and will shadow $EMACSDIR. Move or remove it, then re-run."
fi
if [[ -e "$HOME/.doom.d" && "$DOOMDIR" != "$HOME/.doom.d" ]]; then
  warn "~/.doom.d exists and takes precedence over $DOOMDIR. Consider removing it."
fi

if [[ $EUID -eq 0 ]]; then
  SUDO=""
else
  command -v sudo >/dev/null || die "sudo not found and not running as root"
  SUDO="sudo"
fi

# ---------------------------------------------------------- system packages --

if (( SKIP_APT )); then
  skip "SKIP_APT=1, not touching apt"
else
  command -v apt-get >/dev/null || die "apt-get not found; this script targets Ubuntu/Debian"

  # Leave an existing emacs alone -- it may be a source build or deliberately
  # shadowed on PATH, and we should not second-guess it.
  if command -v emacs >/dev/null; then
    skip "emacs already present ($(command -v emacs)), not installing $EMACS_PKG"
  else
    log "installing $EMACS_PKG"
    run $SUDO apt-get update -qq
    run $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y "$EMACS_PKG"
  fi

  missing=()
  for pkg in "${APT_PACKAGES[@]}"; do
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "^install ok installed$" \
      || missing+=("$pkg")
  done

  if (( ${#missing[@]} )); then
    log "installing: ${missing[*]}"
    run $SUDO apt-get update -qq
    run $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}"
  else
    skip "all system packages already installed"
  fi
fi

# ------------------------------------------------------------------ ~/.bashrc --

# Match on the path fragment, not an exact line, so a hand-written export
# already in ~/.bashrc counts and we do not append a duplicate.
if [[ -f "$BASHRC" ]] && grep -qs '\.config/emacs/bin' "$BASHRC"; then
  skip "~/.bashrc already puts doom on PATH"
elif (( CHECK_ONLY )); then
  printf '    \033[2m[would append]\033[0m PATH export to %s\n' "$BASHRC"
else
  log "adding doom to PATH in ~/.bashrc"
  cat >>"$BASHRC" <<'EOF'

# >>> doom emacs >>>
export PATH="$HOME/.config/emacs/bin:$PATH"
# <<< doom emacs <<<
EOF
fi

# ----------------------------------------------------------- this repository --

# The config must exist before `doom install` runs, so doom syncs against it
# instead of generating a stub. Note this script normally lives inside the
# repo, in which case there is nothing to clone.
if [[ -d "$DOOMDIR/.git" ]]; then
  skip "$DOOMDIR already cloned"
elif [[ -e "$DOOMDIR" ]] && [[ -n "$(ls -A "$DOOMDIR" 2>/dev/null)" ]]; then
  die "$DOOMDIR exists, is not a git repo, and is not empty. Move it aside."
else
  log "cloning config to $DOOMDIR"
  # Prefer ssh so `git push` authenticates via ssh key; fall back to https on a
  # fresh box with no key registered, and say so.
  if (( CHECK_ONLY )); then
    printf '    \033[2m[would clone]\033[0m %s -> %s\n' "$CONFIG_REPO" "$DOOMDIR"
  elif ! git clone "$CONFIG_REPO" "$DOOMDIR" 2>/dev/null; then
    warn "ssh clone failed, falling back to https (read-only)."
    warn "to push later: git -C $DOOMDIR remote set-url origin $CONFIG_REPO"
    git clone "$CONFIG_REPO_HTTPS" "$DOOMDIR"
  fi
fi

# -------------------------------------------------------------- config profile --

# config.el reads this marker to decide which *-config.el to load. Only written
# when --config is passed; absent, config.el falls back to typical-config.
if [[ -n "$CONFIG_PROFILE" ]]; then
  if [[ ! -e "$DOOMDIR/$CONFIG_PROFILE" ]] && (( ! CHECK_ONLY )); then
    die "no such profile: $DOOMDIR/$CONFIG_PROFILE"
  fi
  log "selecting config profile: $CONFIG_PROFILE"
  if (( CHECK_ONLY )); then
    printf '    \033[2m[would write]\033[0m %s -> %s\n' "$CONFIG_PROFILE" "$DOOMDIR/.doom-config"
  else
    printf '%s\n' "$CONFIG_PROFILE" >"$DOOMDIR/.doom-config"
  fi
elif [[ -f "$DOOMDIR/.doom-config" ]]; then
  skip "config profile already set to $(<"$DOOMDIR/.doom-config")"
else
  skip "no --config given, config.el will use typical-config.el"
fi

# ------------------------------------------------------------------ doom core --

if [[ -d "$EMACSDIR/.git" ]]; then
  skip "doom core already cloned at $EMACSDIR"
else
  log "cloning doom core to $EMACSDIR"
  run git clone --depth 1 "$DOOM_CORE_REPO" "$EMACSDIR"
fi

# `doom install` bootstraps; once .local exists a sync is the correct re-run.
# --no-config: our cloned config is already in place, do not stub over it.
# --force:     no prompts, so this works unattended from a parent script.
if [[ -d "$EMACSDIR/.local" ]]; then
  log "doom already installed, syncing"
  run "$EMACSDIR/bin/doom" sync --force
else
  log "running doom install (this takes a while on first run)"
  run "$EMACSDIR/bin/doom" install --force --no-config
fi

# ----------------------------------------------------------------------- done --

if (( CHECK_ONLY )); then
  log "check complete, nothing was modified"
else
  log "done. open a new shell (or 'source ~/.bashrc'), then run: doom doctor"
fi
