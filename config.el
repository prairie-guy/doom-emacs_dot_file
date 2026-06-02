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
;;(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-horizon)
;;(setq doom-theme 'doom-monokai-pro)
(setq doom-theme 'doom-sourcerer)

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
;;  Current stack (updated 2026-06): GNU Emacs 30.2 + Doom Emacs, terminal-only.
;;
;;  Install Emacs 30.x on Ubuntu 24.04 (terminal-only build):
;;  - sudo add-apt-repository ppa:ubuntuhandbook1/emacs
;;  - sudo apt update
;;  - sudo apt install emacs-nox emacs-common
;;
;;  Install Emacs on macOS:
;;  - brew install emacs-plus    (https://github.com/d12frosted/homebrew-emacs-plus)
;;
;;  Search/find tools Doom uses:
;;  - sudo apt install git ripgrep fd-find
;;
;;  Install Doom (modern XDG location):
;;  - git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
;;  - ~/.config/emacs/bin/doom install
;;
;;  Doom binaries live in ~/.config/emacs/bin (on PATH):
;;  - doom sync     # run after editing init.el or packages.el (NOT needed for config.el)
;;  - doom doctor   # check environment/config consistency
;;  - doom upgrade  # update Doom itself + packages
;;  - doom docs     # documentation (or in-Emacs: 'SPC h d h' / 'C-h d h')
;;
;;  Personal configuration lives in ~/.doom.d/ :
;;  - init.el      # enable/disable Doom modules + flags (run 'doom sync' after edits)
;;  - packages.el  # extra packages via (package! ...) (run 'doom sync' after edits)
;;  - config.el    # THIS file -- personal customization (no sync needed)


;;
;; -----------------------------------------
;; -- CBD general changes --
;; -----------------------------------------
;;
(setq! evil-want-Y-yank-to-eol nil)
(setq evil-move-cursor-back nil)
(setq split-width-threshold 80) ; Split screen side-by-side if min 80 width
;;;;(global-set-key "\C-h" 'delete-backward-char) ; required to fix DEL key -- Need to reassign help

;; Buffer use vertico-style mini-buffer. C-x b works, but my fingers still use C-x C-b
;;(map! "C-x C-b" #'+vertico/switch-workspace-buffer)
(map! "C-x C-b" #'+vertico/switch-workspace-buffer)
;;
(global-set-key (kbd "C-x b") 'ibuffer)

;; -----------------------------------------
;; -- Global iPad Mouse/Trackpad Scrolling --
;; -----------------------------------------
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)

;; -----------------------------------------
;; -- Undo-tree--mode configuration --
;; -- Added in init.el (undo +tree)
;; -----------------------------------------
;; undo-tree package added
(global-undo-tree-mode)

;; ---------------------------
;; -- smartparens configuration --
;; ---------------------------
(smartparens-global-strict-mode)
(show-smartparens-global-mode)
(define-key smartparens-mode-map (kbd "C-<right>") 'sp-forward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-<left>")  'sp-backward-slurp-sexp)
(define-key smartparens-mode-map (kbd "M-<right>") 'sp-forward-barf-sexp)
(define-key smartparens-mode-map (kbd "M-<left>")  'sp-backward-barf-sexp)
(define-key smartparens-mode-map (kbd "C-M-]")     'sp-unwrap-sexp)
(define-key smartparens-mode-map (kbd "C-M-[")     'sp-backward-unwrap-sexp)
(define-key smartparens-mode-map (kbd "C-c (")     'sp-wrap-round)
(define-key smartparens-mode-map (kbd "C-c {")     'sp-wrap-curly)
(define-key smartparens-mode-map (kbd "C-c [")     'sp-wrap-square)
(defun sp-wrap-quote ()
  "Wrap following sexp in double-quote."
  (interactive)
  (sp-wrap-with-pair "\""))
(define-key smartparens-mode-map (kbd "C-c \"") 'sp-wrap-quote);; Wrap expression with \"

(defun sp-wrap-back-quote ()
  "Wrap following sexp in back-quote."
  (interactive)
  (sp-wrap-with-pair "`"))
(define-key smartparens-mode-map (kbd "C-c `") 'sp-wrap-back-quote);; Wrap expression with \`


;; ---------------------------
;; -- company configuration --
;; ---------------------------
(global-company-mode)
(after! company (add-to-list 'company-backends 'company-files)) ;; open filenames
(global-set-key (kbd "C-c f c") 'company-files) ;; Acticate company filename search
(define-key company-active-map (kbd "\C-n") 'company-select-next)
(define-key company-active-map (kbd "\C-p") 'company-select-previous)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)

;; -------------------------------------------
;; -- Org Mode Configuration ---
;; -------------------------------------------

(setq
 org-hide-emphasis-markers t
 org-fontify-done-headline t
 org-hide-leading-stars t
 org-pretty-entities t
 org-ascii-text-width 95)

;; Within in an org-file, org-insert-link (C-c C-l) can create link [[img/foo.jpg]]
;; to be embedded within a single html file when called with
;; M-x org-html-export-to-html
;; https://www.reddit.com/r/orgmode/comments/12gxa8s/how_to_generate_a_single_htmlfile_with_embedded/
;; https://www.youtube.com/watch?v=eaZUZCzaIgw (YouTube Video on how to create the function defined here)
(with-eval-after-load 'ol
    (org-link-set-parameters
     "img"
     :follow (lambda (path arg) (org-link-open-as-file path arg))
     :export (lambda (path desc backend cchannel)
               (cond ((eq backend 'html)
                      (format "<img style=\"max-width:95%%;margin:2em\" src=\"data:%s;base64,%s\">"
                              (mailcap-file-name-to-mime-type path)
                              (base64-encode-string
                               (with-temp-buffer
                                 (insert-file-contents path)
                                  (buffer-string)))))))))

;; Does the same for pdf files, but doesn't seem to work
(with-eval-after-load 'ox-latex
(add-to-list 'org-latex-inline-image-rules `("img" . ,(rx "."
                   (or "pdf" "jpeg" "jpg" "png" "ps" "eps" "tikz" "pgf" "svg")
                   eos))))


;; -------------------------------------------
;; -- Markdown  ---
;; -------------------------------------------
;; Add markdown-mode for files with .qmd extension
(add-to-list 'auto-mode-alist '("\\.qmd\\'" . markdown-mode))



;; -------------------------------------------
;; -- Bibtex  Mode Configuration ---
;; -------------------------------------------
(setq bibtex-dialect 'biblatex)

;; -------------------------------------------
;; -- citar  Mode Configuration ---
;; -------------------------------------------
(use-package citar
  :bind (("C-c b" . citar-insert-citation)
         :map minibuffer-local-map
         ("M-b" . citar-insert-preset))
  :custom
  (citar-bibliography  '("/home/cdaniels/uofc/Articles/bibtex-lib/refs.bib")))

(setq! citar-library-paths '("/home/cdaniels/uofc/Articles/articles-lib")
       citar-notes-paths   '("/home/cdaniels/uofc/Articles/articles-notes"))
(setq citar-templates
      '((main . "${author editor:30}     ${date year issued:4}     ${title:48}")
        (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:*}")
        (preview . "${author editor} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
        (note . "Notes on ${title}

* Reference:
${author editor} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}. DOI: https://doi.org/${DOI}, PMID: ${PMID}

* Abstract"))) ;; DONT MESS UP FORMAT OF THIS CITAR BLOCK

(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))


;; ---------------------------
;; -- Python configuration --
;; ---------------------------
(setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
(setq +python-jupyter-repl-args '("--simple-prompt"))

;;Choose python or iPython
;(setq python-shell-interpreter "ipython") ;; Much nicer environment
;(setq python-shell-interpreter "/home/cdaniels/mambaforge/envs/fastai/bin/python")

(defun python-send-region-or-buffer-switch ()
  (interactive)
  (python-shell-send-buffer)
  (python-shell-switch-to-shell))
(add-hook 'python-mode-hook (lambda ()
 (define-key python-mode-map  (kbd "C-c C-b") 'python-send-region-or-buffer-switch)))

(defun disable-smartparens-strict-mode ()
  (interactive)
  (smartparens-strict-mode -1))
(add-hook 'inferior-python-mode-hook #'disable-smartparens-strict-mode)


;; -------------------------------------------
;; -- Julia Snail Mode Configuration ---
;; -------------------------------------------
;; julia not uncommented in .doom.d/init.el
;; julia, julia-repl julia-snail package added
;;

(set-language-environment "UTF-8")
;;(add-to-list 'load-path "/path/to/julia-snail")
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

