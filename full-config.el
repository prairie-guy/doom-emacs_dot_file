;;; $DOOMDIR/full-config.el -*- lexical-binding: t; -*-
;;
;; EVERYTHING. typical-config.el plus the academic bibliography stack.
;;
;; Machine-specific: the citar paths below point at ~/uofc/Articles/, which
;; exists only on the research machine. citar will simply find no entries
;; elsewhere -- it does not error -- but there is no reason to load it there.

(load! "typical-config")

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


