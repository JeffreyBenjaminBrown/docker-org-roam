This builds a Docker container that lets you run [org-roam](https://org-roam.readthedocs.io/) in [Emacs](https://www.gnu.org/software/emacs/).

# How to use it

There are other ways to run it; here's what I do:
```
docker run -ti --name roam							\
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro				\
  -e DISPLAY="unix$DISPLAY"							\
  -e UNAME="emacser"								\
  -e GNAME="emacsers"								\
  -e UID="1000"										\
  -e GID="1000"										\
  -v /home/jeff/org/roam/mnt-data:/mnt/roam-data	\
  -v /home/jeff/org/roam/mnt-misc:/mnt/misc			\
  jeffreybbrown/org-roam:worked						\
  bash
```

The two lines that start with `-v /home/jeff/org/roam/mnt-` are specific to my computer; they mount two folders on my host system (listed to the left of the colon) to two folders in the Docker container (to the right of the colon). The `roam-data` folder is where your `org-roam` database will reside. The other one isn't really necessary, but it might be handy for transferring things between the host system and the Docker container, such as your Emacs configuration, without mixing them up with your database, which might be large.

Once it starts, run `sudo emacs` to launch Emacs. If you ever run into a permission problem, you can hack your way around it with `sudo`. If you know how to change the `Dockerfile` to avoid such problems, please send me a pull request!


# How to generate or modify the `.emacs` file and `.emacs.d/` folder

The Dockerfile pulls those in. I had to generate them using an earlier version of the Docker container that did not have them. Here are the steps I took to do that:

First, from bash in the Docker container, delete the existing `.emacs` content, then start Emacs:

```
cd /home/emacs
rm .emacs.d -rf
emacs
```

From within Emacs, evaluate this code, and save it as `/home/emacs/.emacs.d/init.el`:

```
(package-initialize)
(add-to-list 'package-archives
             '("melpa" .
               "http://melpa.milkbox.net/packages/") t)
```

Then install `use-package` and `org-roam`:
```
`M-x package-list-packages`
`M-x package-refresh`
<mark them for installation with `i`> 
<install them with `x`>
```

Then append some code to `init.el` and reload it:
```
(use-package org-roam
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory
   "/mnt/roam") ;; for the roam db
  :bind (:map org-roam-mode-map
          ( ("C-c n l" . org-roam)
            ("C-c n f" . org-roam-find-file)
            ("C-c n b" . org-roam-buffer-toggle-display)
            ("C-c n g" . org-roam-show-graph))
          :map org-mode-map
          ( ("C-c n i" . org-roam-insert))))
```

Then exit Emacs and copy `emacs` and `.emacs.d` from the Docker container to the host system.

Last, on the host system, remove `.emacs.d/elpa/gnupg`, because it has symlinks and it's easily regenerated.
