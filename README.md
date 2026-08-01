# doom-emacs_dot_file 
My personal doom-emacs configuration, tuned for my needs. It is customized from the default doom-emacs. I didn't want to use evil, so I unplugged it. This is based on the configuration I had in: https://github.com/prairie-guy/emacs_dotfile 

### Installing on Ubuntu emacs27 or greater:
* add-apt-repository ppa:kelleyk/emacs
* apt-get update
* apt remove --autoremove emacs emacs-common (For old versions)
* apt-get install emacs28

### Installing on OSx emacs26 or greater:
* brew tap d12frosted/emacs-plus
* brew install emacs-plus
* ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications/Emacs.app

### Install ripgrep, a faster grep: (https://github.com/BurntSushi/ripgrep)
* Linux: apt-get install git ripgrep
* OSx: brew install ripgrep

### Install fd, a faster find: (https://github.com/sharkdp/fd)
* Linux: apt-get install fd-find
* OSx : brew install coreutils fd

### Other system sequirements (vterm, make, cmake, xclip)
* apt-get install libvterm-dev
* apt-get install make cmake
* apt-get install xclip

### Locations (doom v3 / XDG -- these changed from the old ~/.emacs.d layout):
* `~/.config/emacs/` - doom itself. Don't change anything here.
* `~/.config/doom/`  - this repository. All configuration goes here.
* Doom still falls back to the legacy `~/.emacs.d` and `~/.doom.d` if they exist.
  Do not leave a stray `~/.emacs.d` lying around: emacs prefers it over
  `~/.config/emacs`, and doom will silently not load at all.

### Edit ~/.bashrc
* `export PATH="$HOME/.config/emacs/bin:$PATH"`

### Clone ~/.config/doom (This repository)
* Do this before installing doom-emacs.
* `git clone git@github.com:prairie-guy/doom-emacs_dot_file.git ~/.config/doom`
* Remember to use ssh-address to clone this repository. That allows `git push` authentication through ssh-key.

### Install doom:
* git clone --depth 1 https://github.com/doomemacs/core ~/.config/emacs
* ~/.config/emacs/bin/doom install (doom install)
* doom sync

### doom binaries are located in ~/.config/emacs/bin:
* doom sync  
* doom doctor 

### Configuration is done in ~/.config/doom/
* init.el - General parameter selections. Select options. No additions.
* package.el  - Add additional packages here. Don't use melpa or add package management.
* config.el - This is where personal customization should take place

### doom documentation:
* https://github.com/doomemacs/core/blob/master/docs/getting_started.org
* https://github.com/doomemacs/core/blob/master/docs/faq.org
* Caveat: upstream `getting_started.org` is stale and still documents the old
  `~/.emacs.d` layout. The doom `README.md` is the current source of truth.
* Modules now live in their own repo (https://github.com/doomemacs/modules),
  checked out locally under `~/.config/emacs/sources/doom+/modules/`:
  * `.../modules/editor/evil/README.org` to unplug evil
  * `.../modules/config/default/+emacs-bindings.el` for emacs only bindings



