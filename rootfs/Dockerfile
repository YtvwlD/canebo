FROM ubuntu:noble
RUN apt update
# make the image bootable
RUN apt install --yes --no-install-recommends linux-generic
RUN apt install --yes --no-install-recommends systemd
RUN ln -s /lib/systemd/systemd init
# gdm needs this
RUN apt install --yes --no-install-recommends gdm3
RUN apt install --yes --no-install-recommends python3-gi
RUN apt install --yes --no-install-recommends rtkit
RUN apt install --yes --no-install-recommends orca
# deleting all users makes gdm start gnome-initial-setup, if it's installed
RUN userdel ubuntu
RUN apt install --yes --no-install-recommends gnome-initial-setup
