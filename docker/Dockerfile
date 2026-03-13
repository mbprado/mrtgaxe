FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install useful tools for menus
RUN apt-get update && \
    apt-get install -y bash dialog psmisc curl mrtg busybox jq bc && \
    apt-get clean

# Create volume mount point
VOLUME ["/mrtgaxe/mrtg"]
VOLUME ["/mrtgaxe/miners"]

WORKDIR /mrtgaxe

# Copy scripts
COPY mrtgaxe_set.sh /mrtgaxe/mrtgaxe_set.sh
COPY mrtgaxe_run.sh /mrtgaxe/mrtgaxe_run.sh
COPY mrtgaxe_stop.sh /mrtgaxe/mrtgaxe_stop.sh
COPY mrtgaxe_get.sh /mrtgaxe/mrtgaxe_get.sh
COPY menu.sh /mrtgaxe/menu.sh
COPY mrtg.cfg /mrtgaxe/mrtg.cfg
COPY logo.png /mrtgaxe/logo.png

RUN chmod +x /mrtgaxe/*.sh

ENV IAM="docker"
# Expose port
EXPOSE 9999

# Start interactive shell
ENTRYPOINT ["tail"]
