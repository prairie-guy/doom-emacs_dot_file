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

;; `C-x o' normally CYCLES windows, which is awkward with 3+ windows (e.g. treemacs
;; + code + vterm) -- hard to land on the one you want, like getting back into vterm.
;; ace-window labels each window with a letter so you jump DIRECTLY to it.
(global-set-key (kbd "C-x o") #'ace-window)

;; -----------------------------------------
;; -- Global iPad/Trackpad Scrolling --
;; -----------------------------------------
;; Emacs 30 / blink.app report scroll as <wheel-up>/<wheel-down> (the old
;; <mouse-4>/<mouse-5> no longer fire here). Bind both so trackpad scrolling
;; works in blink AND on the shared Mac. A few lines per notch feels natural.
(defun cbd/scroll-up-a-bit ()   (interactive) (scroll-up 3))
(defun cbd/scroll-down-a-bit () (interactive) (scroll-down 3))
(dolist (ev '("<wheel-down>" "<mouse-5>"))
  (global-set-key (kbd ev) #'cbd/scroll-up-a-bit))
(dolist (ev '("<wheel-up>" "<mouse-4>"))
  (global-set-key (kbd ev) #'cbd/scroll-down-a-bit))
;; Terminal Emacs only receives mouse/wheel events when xterm-mouse-mode is on.
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; -----------------------------------------
;; -- Modern UI niceties (terminal-safe) --
;; -----------------------------------------
;; Smoother scrolling: keep the cursor a few lines off the screen edges.
(setq scroll-margin 4
      scroll-conservatively 101)

;; hl-line is on (global-hl-line-mode), but in a 256-color terminal doom-one's
;; hl-line bg collapses to plain black == the default bg, so the current line is
;; invisible. Force a visibly-distinct background for the current line in -nw.
;;
;; Also: in completion popups the MATCHED letters were colored 'lightblue'
;; (completions-common-part), which is hard to read. Make matched text readable
;; -- bold + a high-contrast yellow, no masking -- and same for orderless groups.
;; KEY: doom-one gives these match faces a BACKGROUND (e.g. blue #51afef) that
;; masks the letters. Clear the background (:background unspecified) so matched
;; text is just bold + a readable color on the normal bg -- the "transparent" look.
(custom-set-faces!
  '(hl-line :background "color-236")     ; dark grey, distinct from black
  '(completions-common-part   :foreground "brightyellow"  :background unspecified :weight bold)
  '(completions-first-difference :foreground "brightred"  :background unspecified :weight bold)
  '(orderless-match-face-0  :foreground "brightyellow"  :background unspecified :weight bold)
  '(orderless-match-face-1  :foreground "brightcyan"    :background unspecified :weight bold)
  '(orderless-match-face-2  :foreground "brightgreen"   :background unspecified :weight bold)
  '(orderless-match-face-3  :foreground "brightmagenta" :background unspecified :weight bold))

;; Rainbow-colored nested delimiters in code buffers.
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; File-type icons in dired (needs a Nerd Font in the terminal -- blink has one).
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)

;; Symbol-kind icons in the corfu completion popup.
(after! corfu
  (when (require 'nerd-icons-corfu nil t)
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)))

;; -----------------------------------------
;; -- Undo configuration --
;; -----------------------------------------
;; Doom's :emacs undo module provides undo-fu + persistent undo-fu-session.
;; vundo gives a visual undo tree. Bind it to C-x u (the key undo-tree used to
;; grab) so existing muscle memory opens the tree, plus SPC o u via the leader.
(map! "C-x u" #'vundo
      :leader :desc "Visual undo tree" "o u" #'vundo)

;; In the vundo tree: n/p reversed per preference (n = backward/left/older,
;; p = forward/right/newer; default f/b still work), and C-a/C-e jump to the
;; very front (oldest) / back (newest) of the undo chain, like line start/end.
(after! vundo
  (define-key vundo-mode-map (kbd "n") #'vundo-backward)
  (define-key vundo-mode-map (kbd "p") #'vundo-forward)
  (define-key vundo-mode-map (kbd "C-a") #'vundo-stem-root)   ; oldest state
  (define-key vundo-mode-map (kbd "C-e") #'vundo-stem-end))   ; newest state

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
;; -- corfu completion configuration --
;; ---------------------------
;; Migrated from company (now deprecated in Doom). The :completion corfu module
;; turns corfu on globally, auto-enables corfu-terminal (because :os tty is set),
;; auto-adds cape-file to completion, and already enables corfu-popupinfo-mode.
;; So we only re-add the two custom company keybindings we were used to:
(after! corfu
  ;; C-n/C-p already select next/prev by default. C-d: toggle the docs popup
  ;; (was company-show-doc-buffer).
  (define-key corfu-map (kbd "C-d") #'corfu-popupinfo-toggle))

;; File-path completion is already automatic via cape-file, but keep the explicit
;; C-c f c key (was company-files) for muscle memory.
(defun cbd/complete-file ()
  "Complete a file path at point via cape-file."
  (interactive)
  (let ((completion-at-point-functions (list #'cape-file)))
    (completion-at-point)))
(global-set-key (kbd "C-c f c") #'cbd/complete-file)

;; -------------------------------------------
;; -- Org Mode Configuration ---
;; -------------------------------------------

(setq
 org-hide-emphasis-markers t
 org-fontify-done-headline t
 org-hide-leading-stars t
 org-pretty-entities t
 org-ascii-text-width 95)

;; org-modern + org-appear come from Doom's (org +pretty) flag and are already
;; enabled/configured by Doom -- we only layer terminal-friendly tweaks on top.
;; (block-fringe uses GUI fringe bitmaps; disable so blocks look right in -nw.)
(after! org-modern
  (setq org-modern-block-fringe nil))

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

;; Keep markdown plain and normal: raw markup is VISIBLE while editing (like a
;; normal text file). The only tweak is native syntax-highlighting of fenced
;; code blocks. No forced markup-hiding, no surprises.
(after! markdown-mode
  (setq markdown-fontify-code-blocks-natively t))

;; When you want a clean READING view, run M-x markdown-toggle-view: it switches
;; to the read-only `markdown-view-mode' (markup hidden); run it again to return
;; to editing. Toggles correctly from either state.
(defun markdown-toggle-view ()
  "Toggle between `markdown-mode' (edit) and `markdown-view-mode' (read-only)."
  (interactive)
  (cond ((eq major-mode 'markdown-view-mode) (markdown-mode))
        ((eq major-mode 'markdown-mode)      (markdown-view-mode))
        (t (user-error "Not in a Markdown buffer (mode is %s)" major-mode))))



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

