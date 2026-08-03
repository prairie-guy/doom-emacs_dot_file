;;; $DOOMDIR/typical-config.el -*- lexical-binding: t; -*-
;;
;; THE DEFAULT PROFILE. base-config.el plus the day-to-day tooling: corfu
;; completion tweaks, python, julia and claude-code.
;;
;; Needs beyond base: a python interpreter, julia (via juliaup) and the claude
;; CLI. Each section degrades quietly if its tool is absent -- julia-snail and
;; claude-code are both lazy -- so this profile is still safe on a bare box.

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
;; -- Claude Code in Emacs --
;; -------------------------------------------
;; Runs the Claude Code CLI in a vterm buffer. Reuses your existing Claude Code
;; OAuth (no API key). Lazy -- package loads on first use.
;;   C-c k  -> opens the Claude Code COMMAND PALETTE (transient menu). From it,
;;             press the listed letter: c=start, s=send region, f=send file,
;;             t=toggle window, etc. This is the menu-first workflow.
;; (C-c k chosen because C-c c=compile and C-c a=embark-act are taken.)
;; C-c k is bound below (cbd/claude-code-palette) to show the palette at the
;; bottom of the frame.
(use-package! claude-code
  :defer t
  :config
  (setq claude-code-terminal-backend 'vterm)
  (claude-code-mode))

;; Show ONLY the claude-code palette pinned to the bottom of the frame (like the
;; SPC leader / which-key), without changing the global transient position (which
;; Doom/magit set to below-the-window). Scoped via a let-bound display action
;; around just this command -- leaves magit and other transients untouched.
(defun cbd/claude-code-palette ()
  "Open the claude-code transient palette at the bottom of the frame."
  (interactive)
  (let ((transient-display-buffer-action
         '(display-buffer-in-side-window
           (side . bottom)
           (dedicated . t)
           (inhibit-same-window . t))))
    (call-interactively #'claude-code-transient)))
(global-set-key (kbd "C-c k") #'cbd/claude-code-palette)

