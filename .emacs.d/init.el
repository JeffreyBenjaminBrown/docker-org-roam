(package-initialize)

(add-to-list 'package-archives
             '("melpa" .
               "http://melpa.milkbox.net/packages/") t)

(use-package org-roam
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory
   "/mnt/roam-data") ;; for the roam db
  :bind (:map org-roam-mode-map
          ( ("C-c n l" . org-roam)
            ("C-c n f" . org-roam-find-file)
            ("C-c n b" . org-roam-buffer-toggle-display)
            ("C-c n c" . org-roam-db-build-cache)
            ("C-c n g" . org-roam-show-graph))
          :map org-mode-map
          ( ("C-c n i" . org-roam-insert))))

;; something like this
(setq org-roam-capture-templates
      '(("u" "public" plain
         (function org-roam--capture-get-point)
         "%?"
         :file-name "tech/%<%Y%m%d%H%M%S>-${slug}"
         :head "#+title: ${title}\n"
         :unnarrowed t)
        ("r" "private" plain
         (function org-roam--capture-get-point)
         "%?"
         :file-name "pers/%<%Y%m%d%H%M%S>-${slug}"
         :head "#+title: ${title}\n"
         :unnarrowed t)))
