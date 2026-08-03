# doom-emacs_dot_file

My personal doom-emacs configuration, tuned for my needs. It is customized from
the default doom-emacs. I didn't want to use evil, so I unplugged it. This is
based on the configuration I had in: https://github.com/prairie-guy/emacs_dotfile

---

## Automated install

`setup.sh` performs the whole install below in one step. It is written to be
called as a module from a parent provisioning script (`setup-linux-server.sh`),
or run on its own.

```
git clone git@github.com:prairie-guy/doom-emacs_dot_file.git ~/.config/doom
~/.config/doom/setup.sh
```

Or fully unattended from a parent script, which may clone this repo first or
let `setup.sh` do it:

```
# in setup-linux-server.sh
~/.config/doom/setup.sh
```

It needs `sudo` for the apt step only; everything else is per-user. If you are
not root it will invoke `sudo` itself, so run it as your normal user, not under
`sudo`.

**It is idempotent.** Re-running is safe: apt packages are checked with
`dpkg-query` before installing, clones are skipped if the directory is already
a git repo, the `~/.bashrc` PATH export is matched on the `.config/emacs/bin`
fragment (so a hand-written export already in your bashrc counts and nothing is
appended twice), and once doom is installed it runs `doom sync` rather than
`doom install`.

Preview what it would do without touching anything:

```
~/.config/doom/setup.sh --check
```

Pick a configuration profile for the machine with `--config` (see
[Configuration profiles](#configuration-profiles) below):

```
~/.config/doom/setup.sh --config base-config.el
```

Behavior can be overridden by environment variable:

| variable | default | purpose |
|---|---|---|
| `EMACS_PKG` | `emacs-nox` | apt package for emacs |
| `DOOMDIR` | `~/.config/doom` | config location |
| `EMACSDIR` | `~/.config/emacs` | doom core location |
| `CONFIG_REPO` | `git@github.com:prairie-guy/...` | this repo's clone URL |
| `SKIP_APT` | `0` | set to `1` to let the parent script own all apt installs |

Two behaviors worth knowing:

* **An existing `emacs` on `PATH` is left alone.** If you already have one --
  a source build, or something deliberately shadowing the distro package --
  the script will not install `emacs-nox` over it.
* **It aborts if `~/.emacs.d` exists**, because emacs prefers that path over
  `~/.config/emacs` and doom would silently not load at all. Move it aside and
  re-run.

The clone prefers the ssh remote so `git push` authenticates through your ssh
key. On a fresh box with no key registered with GitHub it falls back to https
and tells you how to switch the remote back.

---

## Manual install (Ubuntu 24.04, headless server)

What `setup.sh` automates, in order.

### 1. Emacs

```
sudo apt install emacs-nox
```

Ubuntu 24.04 ships Emacs 29.3, which is new enough for doom. `emacs-nox` is the
terminal-only build -- correct for a headless box reached over ssh/mosh. For a
GUI desktop use `emacs30` instead, or on OSX:

```
brew tap d12frosted/emacs-plus
brew install emacs-plus
ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications/Emacs.app
```

### 2. System packages

```
sudo apt install git ripgrep fd-find libvterm-dev pkg-config make cmake libtool-bin
```

* `ripgrep` -- faster grep (https://github.com/BurntSushi/ripgrep)
* `fd-find` -- faster find (https://github.com/sharkdp/fd). Debian/Ubuntu
  install this as `fdfind`, not `fd`; doom checks for both names.
* the rest are the vterm build chain; see the vterm notes below

No `xclip` on a headless box. Clipboard goes through OSC-52 instead -- the
`:os tty +osc` module in `init.el` handles it, and it works over mosh/Blink.
On OSX these are `brew install ripgrep coreutils fd`.

### 3. Edit `~/.bashrc`

```
export PATH="$HOME/.config/emacs/bin:$PATH"
```

That puts `doom` on your path. The bashrc also defines `e`/`emacs` as
`emacs -nw`, plus an optional (not auto-started) daemon workflow: `edaemon-start`
then `ec` to connect, `edaemon-restart` after editing config.

### 4. Clone this repository

Do this **before** installing doom, so doom finds a config on first sync.

```
git clone git@github.com:prairie-guy/doom-emacs_dot_file.git ~/.config/doom
```

Use the ssh address, not https -- that lets `git push` authenticate through your
ssh key.

### 5. Install doom

```
git clone --depth 1 https://github.com/doomemacs/core ~/.config/emacs
~/.config/emacs/bin/doom install
doom sync
doom doctor
```

Note the path: `~/.config/emacs/bin/doom`, **not** `~/.emacs.d/bin/doom`. The
old location no longer exists in doom v3.

---

## Locations (doom v3 / XDG -- these changed from the old `~/.emacs.d` layout)

* `~/.config/emacs/` - doom itself. Don't change anything here.
* `~/.config/doom/`  - this repository. All configuration goes here.
* Doom still falls back to the legacy `~/.emacs.d` and `~/.doom.d` if they exist.
  Do not leave a stray `~/.emacs.d` lying around: emacs prefers it over
  `~/.config/emacs`, and doom will silently not load at all.

## Configuration is done in `~/.config/doom/`

* `init.el` - General parameter selections. Select options. No additions.
* `packages.el` - Add additional packages here. Don't use melpa or add package management.
* `config.el` - Thin profile selector only; the real config is in the profiles below.
* `setup.sh` - Automated installer, above.

## Configuration profiles

Not every machine wants the whole configuration. A headless build server does
not need the julia REPL or a bibliography manager. So the config is split into
three **strictly nested** profiles -- each loads the one below it, so no code is
duplicated:

| profile | contains | needs |
|---|---|---|
| `base-config.el` | keybindings, terminal scrolling, UI, undo, smartparens, org, markdown | nothing beyond `setup.sh` |
| `typical-config.el` | base + corfu tweaks, python, julia, claude-code | python; julia and claude optional (both lazy) |
| `full-config.el` | typical + bibtex/citar | the `~/uofc/Articles/` library |

`typical-config.el` is the default. Select another with:

```
./setup.sh --config base-config.el
```

That writes the profile name to `.doom-config`, which `config.el` reads at
startup. It is gitignored, so a machine's choice never shows up as a modified
`config.el` in `git status`. If the marker is missing, empty, or names a file
that isn't there, `config.el` falls back to `typical-config.el` rather than
failing to load any configuration.

To switch profiles by hand, just edit `.doom-config` (or delete it to get the
default) and restart Emacs. No `doom sync` needed -- that is only for `init.el`
and `packages.el`.

## doom binaries are in `~/.config/emacs/bin`

* `doom sync`
* `doom doctor`

---

## vterm notes

All three of `libvterm-dev`, `pkg-config`, and `libtool-bin` are needed, or the
module fails to build:

* Without `libvterm-dev`, cmake downloads and compiles a bundled libvterm,
  which drags in the autotools path and fails on missing libtool.
* `pkg-config` is how cmake detects the system libvterm. Missing it sends you
  down the bundled path even with libvterm-dev installed.
* The `libtool` package does NOT ship the `libtool` binary on debian/ubuntu --
  that is `libtool-bin`. Installing `libtool` alone gets you `libtoolize` and
  nothing else, and cmake fails with "libtool not found".

If a vterm build has already failed, delete the stale cmake cache before
retrying, then `M-x vterm`:

```
rm -rf ~/.config/emacs/.local/straight/build-*/vterm/build
```

## doom documentation

* https://github.com/doomemacs/core/blob/master/docs/getting_started.org
* https://github.com/doomemacs/core/blob/master/docs/faq.org
* Caveat: upstream `getting_started.org` is stale and still documents the old
  `~/.emacs.d` layout. The doom `README.md` is the current source of truth.
* Modules now live in their own repo (https://github.com/doomemacs/modules),
  checked out locally under `~/.config/emacs/sources/doom+/modules/`:
  * `.../modules/editor/evil/README.org` to unplug evil
  * `.../modules/config/default/+emacs-bindings.el` for emacs only bindings
