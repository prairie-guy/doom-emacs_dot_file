;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "C. Bryan Daniels"
      user-mail-address "cdaniels@nandor.net")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; CBD changed to 'nil
(setq display-line-numbers-type 'nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;
;; -----------------------------------------
;; -- CBD System Requirements and Configuration --
;; -----------------------------------------
;;
;;  Install on Ubuntu emacs26 or greater: (may need )
;;  - add-apt-repository ppa:kelleyk/emacs
;;  - apt-get update
;;  - apt-get install emacs26
;;
;;  Install on OSx emacs26 or greater:
;;  - brew tap d12frosted/emacs-plus
;;  - brew install emacs-plus
;;  - ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications/Emacs.app
;;
;;  Install ripgrep a faster grep (https://github.com/BurntSushi/ripgrep)
;;  - apt-get install git ripgrep
;;
;;  Install fd a faster find (https://github.com/sharkdp/fd)
;;  - apt-get install fd-find
;;
;;  Install doom:
;;  - git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
;;  - ~/.emacs.d/bin/doom install (doom install)
;;  - doom sync
;;
;;  doom documentation:
;;  - https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org
;;  - https://github.com/hlissner/doom-emacs/blob/develop/docs/index.org
;;  - https://github.com/hlissner/doom-emacs/blob/develop/modules/editor/evil/README.org to unplug evil
;;  - https://github.com/hlissner/doom-emacs/blob/develop/modules/config/default/+emacs-bindings.el for emacs only bindings
;;
;;  doom binaries are located in ~/.emacs.d  # Don't change anything here:
;;  - doom sync   # Update after editing configuration files
;;  - doom doctor # Check that system is consistent
;;
;;  Configuration is done in ~/.doom.d/
;;  - init.el     # General parameter selections. Choose options, but don't further configurations
;;  - package.el  # Add additional packages. Don't use melapa or add packages otherwise
;;  - confit.el   # This file. This is where personal customization should take place


;;
;; -----------------------------------------
;; -- CBD general changes --
;; -----------------------------------------
;;
(setq! evil-want-Y-yank-to-eol nil)
(setq evil-move-cursor-back nil)
(setq split-width-threshold 80) ; Split screen side-by-side if min 80 width
;;;;(global-set-key "\C-h" 'delete-backward-char) ; required to fix DEL key -- Need to reassign help

;; -----------------------------------------
;; -- Global iPad Mouse/Trackpad Scrolling --
;; -----------------------------------------
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)

;; -----------------------------------------
;; -- Undo-tree--mode configuration --
;; -----------------------------------------
;; undo-tree package added
(global-undo-tree-mode)

;; ---------------------------
;; -- smartparens configuration --
;; ---------------------------
;; 
(smartparens-global-strict-mode)
(show-smartparens-global-mode)
(define-key smartparens-mode-map (kbd "C-c (") 'sp-wrap-round) ;; Wrap expression with ()
;; ---------------------------
;; -- company configuration --
;; ---------------------------
(global-company-mode)
(define-key company-active-map (kbd "\C-n") 'company-select-next)
(define-key company-active-map (kbd "\C-p") 'company-select-previous)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
(define-key company-active-map (kbd "<tab>") 'company-complete)

;; -------------------------------------------
;; -- Org Mode Configuration ---
;; -------------------------------------------

(setq
 org-hide-emphasis-markers t
 org-fontify-done-headline t
 org-hide-leading-stars t
 org-pretty-entities t
 org-ascii-text-width 95
 )

;; (use-package org-bullets
;;   :hook (org-mode . org-bullets-mode))


;; ---------------------------
;; -- Python configuration --
;; ---------------------------
;; elpy package added
(elpy-enable)

(defun elpy-shell-send-region-or-buffer-switch ()
  (interactive)
  (elpy-shell-send-region-or-buffer)
  (elpy-shell-switch-to-shell))
(define-key elpy-mode-map  (kbd "C-c C-b") #'elpy-shell-send-region-or-buffer-switch)

(defun disable-smartparens-strict-mode ()
  (interactive)
  (smartparens-strict-mode -1))
(add-hook 'inferior-python-mode-hook #'disable-smartparens-strict-mode)


;; -------------------------------------------
;; -- Julia Mode Configuration ---
;; -------------------------------------------
;; julia not uncommented in .doom.d/init.el
;; julia, julia-repl julia-snail package added
;;
;;(add-hook 'julia-mode-hook 'julia-repl-mode)  ; Don't use with julia-snail
(set-language-environment "UTF-8")
(add-to-list 'load-path "/path/to/julia-snail")
(require 'julia-snail)
(add-hook 'julia-mode-hook #'julia-snail-mode)

(defun julia-snail-save-and-send-buffer-file ()
  (interactive)
  (save-buffer)
  (julia-snail-send-buffer-file)
  (julia-snail))
; Save before sending over buffer
(define-key julia-snail-mode-map  (kbd "C-c C-b") #'julia-snail-save-and-send-buffer-file)

(defun julia-|> ()
  "Insert '|> for use with Julia Tranducers"
  (interactive) (insert "|>"))
(define-key julia-snail-mode-map  (kbd "C-c .") 'julia-|> )

(add-to-list 'display-buffer-alist
             '("\\*julia" (display-buffer-reuse-window display-buffer-same-window)))



;; -------------------------------------------
;; -- Clojure Mode Configuration ---
;; -------------------------------------------
(setq cider-show-error-buffer nil)
(setq cljr-suppress-no-project-warning t)
(add-hook 'cider-mode-hook #'eldoc-mode) ; Enable eldoc in Clojure buffers
(use-package cider
 ;:ensure t
 :config
 (setq cider-show-error-buffer nil)

 (defun cider-snail-save-and-eval-buffer ()
  (interactive)
  (save-buffer)
  (cider-load-buffer-and-switch-to-repl-buffer))

 (define-key cider-mode-map (kbd "C-c C-b") 'cider-snail-save-and-eval-buffer)
 (defun run-clojure()
   (interactive)
   (+popup-mode 0)
   (delete-other-windows)
   (setq w1 (selected-window))
   (setq w1name (buffer-name))
   (setq w2 (split-window w1 nil t))
   (cider-jack-in-clj nil)
   (set-window-buffer w2 "*cider*")
   (set-window-buffer w1 w1name))
 )

;; -------------------------------------------
;; -- Hy Mode Configuration ---
;; -------------------------------------------
;(setq hy-shell--interpreter-args '("--spy"))
;(setq hy-shell--interpreter-args '("--repl-output-fn" "hy.contrib.pprint.pformat"))

;; Disable jedhy-mode and company-mode in inferior-hy-mode
;; Alternatively, use vterm and execute hy to regain tabe-complete
;; (setq hy-shell--interpreter-args
;;       '("--repl-output-fn" "hy.contrib.hy-repr.hy-repr")
;;       hy-jedhy--enable? nil)
;; (add-hook 'hy-mode-hook (lambda () (company-mode)))


;; -------------------------------------------
;; -- osc52 Configuration - emacs copy/paste -
;; -------------------------------------------
;(osc52-set-cut-function)
