# doom-emacs_dot_file 
My personal doom-emacs configuration, tuned for my needs. It is customized from the default emacs doom. I don't want to use evil, so I unplugged it. This is based on the configuration I had in: https://github.com/prairie-guy/emacs_dotfile 

### Clone this directory
* git clone git@github.com:prairie-guy/doom-emacs_dot_file.git .doom.d
* Use ssh to clone to allow easy git pull authentication through ssh-key

### Install on Ubuntu emacs26 or greater: (may need )
* add-apt-repository ppa:kelleyk/emacs
* apt-get update
* apt-get install emacs26

### Install on OSx emacs26 or greater:
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
* confit.el   # This file. This is where personal customization should take place

