# doom-emacs_dot_file

My personal doom-emacs configuration, tuned for my needs. It is customized from
the default doom-emacs. I didn't want to use evil, so I unplugged it. This is
based on the configuration I had in: https://github.com/prairie-guy/emacs_dotfile

---

## Install (Ubuntu 24.04, headless server)

This is the path that actually works. Run the steps in order.

### 1. Emacs

```
sudo apt install emacs-nox
```

Ubuntu 24.04 ships Emacs 29.3, which is new enough for doom. `emacs-nox` is the
terminal-only build -- correct for a headless box reached over ssh/mosh.

Two things NOT to bother with (both were tried and abandoned):

* **`ppa:kelleyk/emacs`** -- was added, then removed. The distro package is
  fine and the PPA is an extra moving part. If you do want it back:
  `sudo add-apt-repository ppa:kelleyk/emacs && sudo apt install emacs30`.
* **Building 30.2 from source** -- see the appendix at the bottom. It took four
  attempts to get `./configure` through, and the result was never used. Only go
  down this road if you specifically need native-comp or tree-sitter.

For a GUI desktop instead of a server, use `sudo apt install emacs30` (with the
PPA above), or on OSX:

```
brew tap d12frosted/emacs-plus
brew install emacs-plus
ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications/Emacs.app
```

### 2. System packages

Everything doom needs, in one line:

```
sudo apt install git ripgrep fd-find libvterm-dev pkg-config make cmake libtool-bin
```

* `ripgrep` -- faster grep (https://github.com/BurntSushi/ripgrep)
* `fd-find` -- faster find (https://github.com/sharkdp/fd)
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
* `config.el` - This is where personal customization should take place.

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

---

## Appendix: building Emacs from source (not currently used)

Kept for reference. The distro `emacs-nox` is what is actually installed. If you
need native compilation or tree-sitter, this is the headless configure that
finally got through -- note there is no X, no GUI toolkit, and no image
libraries, which is what removes most of the dependency pain:

```
sudo apt install -y build-essential zlib1g-dev libgccjit-13-dev \
    libtree-sitter-dev libgnutls28-dev libxml2-dev libjansson-dev \
    libncurses-dev libacl1-dev texinfo wget

cd /tmp
wget https://ftp.gnu.org/gnu/emacs/emacs-30.2.tar.xz
tar xf emacs-30.2.tar.xz
cd emacs-30.2

./configure --with-native-compilation=aot --with-tree-sitter --with-json \
            --with-mailutils --with-modules \
            --without-x --without-xpm --without-jpeg --without-png \
            --without-gif --without-tiff --without-webp --without-rsvg \
            --without-imagemagick --without-gpm --without-dbus

make -j$(nproc)
sudo make install     # installs to /usr/local
```

`make -j$(nproc)` with `aot` takes 10-20 minutes. If a previous configure
failed, run `make distclean` first. Remember that `/usr/local/bin` must precede
`/usr/bin` on your PATH for the source build to win over the distro package.
