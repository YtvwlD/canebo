FROM ubuntu:noble
RUN apt update
RUN apt install --yes --no-install-recommends linux-generic
RUN apt install --yes --no-install-recommends systemd
RUN ln -s /lib/systemd/systemd init
RUN apt install --yes --no-install-recommends gdm3
RUN apt install --yes --no-install-recommends python3-gi
RUN apt install --yes --no-install-recommends rtkit
RUN apt install --yes --no-install-recommends orca
