# doom-emacs_dot_file 
My personal doom-emacs configuration, tuned for my needs. It is customized from the default doom-emacs. I didn't want to use evil, so I unplugged it. This is based on the configuration I had in: https://github.com/prairie-guy/emacs_dotfile 

### Clone this directory
* `git clone git@github.com:prairie-guy/doom-emacs_dot_file.git .doom.d`
* Remember to use ssh-address to clone this repository. That allows `git push` authentication through ssh-key.

### Installing on Ubuntu emacs26 or greater:
* add-apt-repository ppa:kelleyk/emacs
* apt-get update
* apt-get install emacs26

### Installing on OSx emacs26 or greater:
* brew tap d12frosted/emacs-plus
* brew install emacs-plus
* ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications/Emacs.app

### Install ripgrep a faster grep (https://github.com/BurntSushi/ripgrep)
* apt-get install git ripgrep

### Install fd a faster find (https://github.com/sharkdp/fd)
* apt-get install fd-find

### Install doom:
* git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
* ~/.emacs.d/bin/doom install (doom install)
* doom sync

### doom documentation:
* https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org
* https://github.com/hlissner/doom-emacs/blob/develop/docs/index.org
* https://github.com/hlissner/doom-emacs/blob/develop/modules/editor/evil/README.org to unplug evil
* https://github.com/hlissner/doom-emacs/blob/develop/modules/config/default/+emacs-bindings.el for emacs only bindings

### doom binaries are located in ~/.emacs.d  # Don't change anything here:
* doom sync   # Update after editing configuration files
* doom doctor # Check that system is consistent

### Configuration is done in ~/.doom.d/
* init.el     # General parameter selections. Choose options, but don't further configurations
* package.el  # Add additional packages. Don't use melapa or add packages otherwise
* config.el   # This file. This is where personal customization should take place

