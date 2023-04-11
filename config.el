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

;; Buffer use vertico-style mini-buffer. C-x b works, but my fingers still use C-x C-b
(map! "C-x C-b" #'+vertico/switch-workspace-buffer)

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

;; Within in an org-file, allows the link [[img/foo.jpg]]
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

;; org-tufte is an org package to "beautify" org-file code to html-code, including inlining images
;; https://github.com/Zilong-Li/org-tufte
;; M-x export-org-tufte-html
;;
;; (add-to-list 'load-path "/home/cdaniels/.doom.d/") ; This is the directory path not the file path
;; (require 'org-tufte)
;; (use-package org-tufte
;;   :ensure nil
;;   :init (add-to-list 'load-path "PATH*")
;;   :config
;;   (require 'org-tufte)
;;   ;(setq org-tufte-htmlize-code t)
;;   )


;; (use-package org-bullets
;;   :hook (org-mode . org-bullets-mode))

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


;; -------------------------------------------
;; -- Pubmed  Mode Configuration ---
;; -------------------------------------------
;; git clone git@github.com:emacsmirror/pubmed.git
;; https://github.com/emacsmirror/pubmed
;; https://openaccessbutton.org/api
;; https://dev.springernature.com/admin/applications

;; (use-package pubmed
;;   :ensure t
;;   :commands (pubmed-search pubmed-advanced-search pubmed-unpaywall pubmed-dissemin pubmed-springer pubmed-scihub))
(require 'pubmed)
(require 'pubmed-advanced-search)
(setq pubmed-api-key "772024ac885b3a0055c302ab295f41ce5c08")
(setq pubmed-bibtex-keypattern "[pmid]")
(setq pubmed-bibtex-default-file "/home/cdaniels/uofc/bibtex-lib/bibliography.bib")
(setq pubmed-bibtex-article-note t) ; How to add extra fields to bibtex
(setq pubmed-bibtex-article-pubmed t)
(setq pubmed-openaccessbutton-api-key "2a98a191b95c9169eb5b1730235c3e")
(setq pubmed-springer-api-key "f3bce4ebf5b2b8c1747cf735b3c30728")
(setq pubmed-unpaywall-email "devnullmenot@gmail.com")
(setq pubmed-scihub-url "https://sci-hub.se")
(require 'pubmed-unpaywall)
(require 'pubmed-dissemin)
(require 'pubmed-springer)
(require 'pubmed-scihub)
(setq pubmed-fulltext-functions '(pubmed-pmc pubmed-openaccessbutton pubmed-unpaywall pubmed-dissemin pubmed-scihub))


;; (defun shell-region (start end)
;;   "execute region in an inferior shell"
;;   (interactive "r")
;;   (shell-command  (buffer-substring-no-properties start end)))


;; ---------------------------
;; -- Python configuration --
;; ---------------------------
;; elpy package added
;; (elpy-enable)
;;
(setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
(setq +python-jupyter-repl-args '("--simple-prompt"))

;(setq python-shell-interpreter "ipython") ;; Much nicer environment

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

;; Set up lsp-julia. NOT configured in init.el
;; (use-package lsp-julia
;;   :config
;;   (setq lsp-julia-default-environment "~/.julia/environments/v1.7"))
;; (add-hook 'julia-snail-mode-hook #'lsp-mode)

;; -------------------------------------------
;; -- Clojure Mode Configuration ---
;; -------------------------------------------

;; CBD UNCOMMENT TO START USING CLOJURE AGAIN. ALSO ADD IN init.el

;; (add-hook 'cider-mode-hook #'eldoc-mode) ; Enable eldoc in Clojure buffers
;; (use-package cider
;;   :config
;;   (setq cider-show-error-buffer nil)
;;   (setq cljr-suppress-no-project-warning t)
;;   (setq cljr-add-ns-to-blank-clj-files nil)
;;   (setq cider-switch-to-repl-on-insert nil)    ; On insert, keep focus in buffer
;;   (setq cider-invert-insert-eval-p t)          ; On insert, evaluate the results
;;   (setq clojure-toplevel-inside-comment-form t); On insert, the (comment ) block is not the top form

;;   (define-key cider-mode-map (kbd "C-c C-v b") 'cider-eval-last-sexp-to-repl)
;;   (define-key cider-mode-map (kbd "C-c RET") 'cider-insert-defun-in-repl)
;;   (define-key cider-mode-map (kbd "C-c C-a") 'cider-format-defun)

;;   (defun cider-save-and-eval-buffer ()
;;     (interactive)
;;     (save-buffer)
;;     (cider-load-buffer-and-switch-to-repl-buffer))
;;   (define-key cider-mode-map (kbd "C-c C-b") 'cider-save-and-eval-buffer)

;;   (defun run-clojure()
;;     (interactive)
;;     (+popup-mode 0)
;;     (delete-other-windows)
;;     (setq w1 (selected-window))
;;     (setq w1name (buffer-name))
;;     (cider-jack-in-clj nil)
;;     (set-window-buffer w1 w1name)
;;     (run-with-timer 5.0 nil 'cider-repl-set-ns (cider-current-ns))))

;; (defun clerk-show ()
;;   (interactive)
;;   (save-buffer)
;;   (let
;;       ((filename
;;         (buffer-file-name)))
;;     (when filename
;;       (cider-interactive-eval
;;        (concat "(nextjournal.clerk/show! \"" filename "\")")))))
;; (define-key clojure-mode-map (kbd "<M-RET>") 'clerk-show) ;; RET in terminal vs. <return> in gui


;; -------------------------------------------
;; -- Clojure-lsp mode Configuration ---
;; -------------------------------------------
                                        ;
;(setq lsp-ui-sideline-show-diagnostics nil) ; lsp-diagnostics can be a pain to have all of the time



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
