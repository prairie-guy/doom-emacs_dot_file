;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;
;; THE DEFAULT CONFIGURATION -- this is the file doom loads. Adjust it freely;
;; it is meant to be edited.
;;
;; It layers the day-to-day language tooling (corfu completion tweaks, python,
;; julia) on top of base-config.el, which holds the portable editor core:
;; keybindings, terminal scrolling, UI, undo, smartparens, org and markdown.
;;
;; For a leaner install -- the editor core with no language tooling -- use
;; base-config.el instead, which is self-contained:
;;
;;   ./setup.sh --config base-config.el
;;
;; That installs base-config.el AS this file. See the README.
;;
;; No `doom sync' is needed after editing this file; that is only for init.el
;; and packages.el.

(load! "base-config")

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

;; ---------------------------
;; -- Python configuration --
;; ---------------------------
(setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
(setq +python-jupyter-repl-args '("--simple-prompt"))

;;Choose python or iPython
;(setq python-shell-interpreter "ipython") ;; Much nicer environment
;(setq python-shell-interpreter "~/miniforge3/envs/<env>/bin/python") ;; pin to a mamba env

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

;; (Python LSP removed -- eglot+basedpyright thrashed when scanning large non-
;; project dirs like ~/junk. Plain python module: highlighting + REPL. File-path
;; completion (C-M-i / C-c f c) and word completion are unaffected -- they come
;; from corfu/cape, not LSP.)


;; -------------------------------------------
;; -- Julia (julia-snail) personal tweaks ---
;; -------------------------------------------
;; julia-mode + julia-snail now come from Doom's (julia +snail) module, which
;; loads/hooks snail for us. We only add personal commands + keybindings here,
;; wrapped in `after!' since julia-snail-mode-map now loads lazily.


(after! julia-snail
  (defun julia-snail-save-and-send-buffer-file ()
    "Save the buffer, send the file to the Julia REPL, then show the REPL."
    (interactive)
    (save-buffer)
    (julia-snail-send-buffer-file)
    (julia-snail))

  (defun julia-|> ()
    "Insert '|>' for use with Julia transducers/pipes."
    (interactive) (insert "|>"))

  ;; Personal bindings (kept from before): C-c C-b = save+send+show REPL.
  (define-key julia-snail-mode-map (kbd "C-c C-b") #'julia-snail-save-and-send-buffer-file)
  (define-key julia-snail-mode-map (kbd "C-c .")   #'julia-|>)

  ;; Reuse the same window for the *julia* REPL buffer.
  (add-to-list 'display-buffer-alist
               '("\\*julia" (display-buffer-reuse-window display-buffer-same-window))))

;; -------------------------------------------
;; -- Bibtex  Mode Configuration ---
;; -------------------------------------------
;; bibtex-mode is built into Emacs; this needs no package. (Kept from the old
;; full-config.el profile, which is gone now that citar has been dropped.)
(setq bibtex-dialect 'biblatex)
