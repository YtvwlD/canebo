# builder
FROM ubuntu:noble as builder
RUN apt update
RUN apt install --yes --no-install-recommends cargo
RUN apt install --yes --no-install-recommends libgtk-4-dev
RUN apt install --yes --no-install-recommends ca-certificates
# get the dependencies
COPY canebo-ui/Cargo.toml canebo-ui/
COPY canebo-ui/Cargo.lock canebo-ui/
RUN mkdir canebo-ui/src && touch canebo-ui/src/lib.rs
RUN cd canebo-ui && cargo build --release
# run the actual build
RUN rm -rf canebo-ui/src
COPY canebo-ui/src canebo-ui/src
RUN cd canebo-ui && cargo build --release

# the actual rootfs
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
# gdm is more useful with this
RUN apt install --yes --no-install-recommends bluez
RUN apt install --yes --no-install-recommends network-manager-gnome
RUN rm /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
RUN apt install --yes --no-install-recommends colord
# deleting all users makes gdm start gnome-initial-setup, if it's installed
RUN userdel ubuntu
RUN apt install --yes --no-install-recommends gnome-initial-setup
# replace gnome-initial-setup with our application
COPY --from=builder canebo-ui/target/release/canebo-ui /usr/libexec/gnome-initial-setup
