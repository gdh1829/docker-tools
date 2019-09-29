FROM ubuntu:18.04

RUN apt-get update \
    && apt-get upgrade \
    && apt-get install -y curl docker.io build-essential sudo
# Matches my user on the host, check with id command on your linux
RUN useradd -u 1000 daehyeop_ko \
    && mkdir -p /home/daehyeop_ko \
    && chown daehyeop_ko:daehyeop_ko /home/daehyeop_ko

RUN echo "alias bundle-install='/opt/chefdk/embedded/bin/bundle install --path vendor --binstubs'" >> /home/daehyeop_ko/.bashrc
RUN curl -O  https://packages.chef.io/files/stable/chefdk/4.3.13/ubuntu/18.04/chefdk_4.3.13-1_amd64.deb \
    && dpkg -i chefdk_4.3.13-1_amd64.deb

ENV PATH="/opt/chefdk/embedded/bin:${PATH}"

RUN echo "%staff ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/staff \
    && usermod -aG staff daehyeop_ko


USER daehyeop_ko