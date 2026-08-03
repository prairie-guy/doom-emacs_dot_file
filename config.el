;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;
;; Thin profile selector -- no configuration of its own. The real config lives
;; in one of three strictly-nested profiles, so nothing is duplicated between
;; them:
;;
;;   base-config.el     portable editor core: keybindings, terminal scrolling,
;;                      UI, undo, smartparens, org, markdown. Runs anywhere.
;;   typical-config.el  base + corfu tweaks, python, julia, claude-code.  DEFAULT
;;   full-config.el     typical + the bibtex/citar bibliography stack.
;;
;; Pick one per machine:
;;
;;   ./setup.sh --config base-config.el
;;
;; which writes the profile name to .doom-config (gitignored, so a machine's
;; choice never dirties the repo). With no marker file, typical-config loads.
;;
;; Editing this file needs no `doom sync'.

(load!
 (file-name-sans-extension
  (let ((marker (expand-file-name ".doom-config" doom-user-dir)))
    (or (and (file-readable-p marker)
             (let ((name (string-trim
                          (with-temp-buffer
                            (insert-file-contents marker)
                            (buffer-string)))))
               ;; Ignore an empty or stale marker rather than failing to load
               ;; any config at all.
               (and (not (string-empty-p name))
                    (file-readable-p
                     (expand-file-name (if (string-suffix-p ".el" name)
                                           name
                                         (concat name ".el"))
                                       doom-user-dir))
                    name)))
        "typical-config"))))
