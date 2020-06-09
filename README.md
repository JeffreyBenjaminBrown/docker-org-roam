This builds a Docker container that lets you run [org-roam](https://org-roam.readthedocs.io/) in [Emacs](https://www.gnu.org/software/emacs/).

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
