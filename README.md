This builds a Docker container that lets you run [org-roam](https://org-roam.readthedocs.io/) in [Emacs](https://www.gnu.org/software/emacs/).

# WARNING: This is old

This uses org-roam version 1.1. I made it because I couldn't install org-roam natively on NixOS. Now I'm able to, so I don't use this anymore. If you really need version 1.2, let me know and I can upgrade it. Barring that, you can do it yourself -- see [TODO.org](TODO.org) for how.

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
  jeffreybbrown/org-roam:latest						\
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

# Known problems

## Your terminal might interpret a few rare key commands differently

This runs Emacs from inside a console session. This might lead key commands to behave strangely. For instance, in my case, Emacs in a Docker container in a Konsole session interprets `C-<page down>` differently than Emacs on my native system (NixOS).

This might be solvable by using `ssh` to sidestep X11 issues, if I understand correctly [someone on the `org-roam` Discourse](https://org-roam.discourse.group/t/theres-a-docker-image-available/331/2?u=jeffbrown).
