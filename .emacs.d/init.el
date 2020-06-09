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
            ("C-c n g" . org-roam-show-graph))
          :map org-mode-map
          ( ("C-c n i" . org-roam-insert))))
