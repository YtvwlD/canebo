FROM ubuntu:noble
RUN apt update
RUN apt install --yes --no-install-recommends linux-generic
RUN apt install --yes --no-install-recommends systemd
RUN ln -s /lib/systemd/systemd init
RUN rm /.dockerenv
