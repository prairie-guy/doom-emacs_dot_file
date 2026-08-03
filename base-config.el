;;; $DOOMDIR/base-config.el -*- lexical-binding: t; -*-
;;
;; PORTABLE EDITOR CORE. Everything here works on a bare server with nothing
;; installed beyond doom itself and what setup.sh provides. No language
;; toolchains, no bibliography stack, no external CLIs.
;;
;; Loaded directly, or as the base layer of typical-config.el / full-config.el.
;; Contains: general keybindings, terminal scrolling, UI, undo, smartparens,
;; org, markdown.

;; Identity -- used by GPG config, file templates and snippets.
(setq user-full-name "C. Bryan Daniels"
      user-mail-address "cdaniels@nandor.net")

;; Fonts are deliberately unset: this config is terminal-first, so the terminal
;; emulator owns the font. See `doom-font' / `doom-variable-pitch-font' if you
;; ever run a GUI frame.
(setq doom-theme 'doom-one)          ; alts tried: doom-horizon, doom-monokai-pro
(setq org-directory "~/org/")        ; must be set before org loads
(setq display-line-numbers-type 'nil)

;; Global, not language-specific (it lived in the Julia section historically).
(set-language-environment "UTF-8")

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

;; NOTE: the on-demand file-path completion key (C-c f c / cbd/complete-file)
;; lives in typical-config.el, not here -- in this profile use C-M-i for normal
;; complete-at-point. It is not made global on purpose: automatic cape-file in
;; prose buffers pops unwanted suggestions on dates/fractions/paths-in-text.

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



