Docker Container DNS
===

## In case of default bridge network

※ in user-defined networks, it works differently. refer to this [user-defined dns link]

How Docker can supply each container with a hostname and DNS configuration, without having to build a custom image with the hostname written inside?

Its trick is to overlay three crucial `/etc` files inside the container with virtual files where it can write fresh information. You can see this by running `mount` inside a container

```bash
...
/dev/sda1 on /etc/resolv.conf type ext4 (rw,relatime,data=ordered)
/dev/sda1 on /etc/hostname type ext4 (rw,relatime,data=ordered)
/dev/sda1 on /etc/hosts type ext4 (rw,relatime,data=ordered)
...
```

This arrangement allows Docker to do clever things like keep `resolv.conf` up to date across all containers when the host machine receives new configuration over DHCP later.

Regarding DNS settings, in the absence of the `--dns=IP_ADDRESS`, `--dns-search=DOMAIN...`, or `--dns-opt=OPTION..` options, Docker makes each container's `/etc/resolv.conf` look like the `/etc/resolv.conf` of the host machine (where the `docker` daemon runs). When creating the container's `/etc/resolv.conf`, the daemon filters out all localhost IP address `nameserver` entries from the hosts original file.

Filtering is necessary because all localhost addresses on the host are unreachable from the container's network. After this filtering, if there are no more `nameserver` entries left in the container's `/etc/resolv.conf` file, the daemon adds public Google DNS nameservers(8.8.8.8 and 8.8.4.4) to the container's DNS configuration. If IPv6 is enabled on the daemon, the public IPv6 Google DNS nameservers will also be added (2001:4860:4860:8888 and 2001:4860:4860:8844).

If you need access to a host's localhost resolver, you must modify your DNS service on the host to listen on a non-localhost address that is reachable from within the container.

what happens when the host machine's `/etc/resolv.conf` file changes: refer to [configure container dns link]

## Docker options to affect container DNS

| options                           | description  |
| --------------------------------- | ------- |
| -h HOSTNAME or --HOSTNAME=HOSTNAME | Sets the hostname by which the container knows itself. This is written into `/etc/hostname`, into `/etc/hosts` as the name of the container's host-facing IP address, and is the name that `/bin/bash` inside the container will display inside its prompt. |
| --link=CONTAINER_NAME or `ID:ALIAS` | Using this option as you `run` a container gives the new container's `/etc/hosts` an extra entry named `ALIAS` that points to the IP address of the container identified by `CONTAINER_NAME_or_ID`. This lets processes inside the new container connect to the hostname `ALIAS` without having to know its IP. Docker may assign a different IP address to the linked containers on restart, Docker updates the `ALIAS` entry in the `/etc/hosts` files of the recipient containers. |
| --dns=IP_ADDRESS…                   | Sets the IP addresses added as `nameserver` lines to the container's /etc/resolv.conf file. Processes in the container, when confronted with a hostname not in `/etc/hosts`, will connect to these IP addresses on port 53 looking for name resolution services. |
| --dns-search=DOMAIN…                | Sets the domain names that are searched when a bare unqualified hostname is used inside of the container, by writing `search` lines into the container's `/etc/resolv.conf`. When a container process attempts to access `host` and the search domain `example.com` is set, for instance, the DNS logic will not only look up `host` but also `host.example.com`. Use `--dns-search=.` if you don't wish to set the search domain. |
| --dns-opt=OPTION…                   | Sets the options used by DNS resolvrs by writing an `options` line into the container's `/etc/resolv.conf`. |

[configure container dns link]: https://docs.docker.com/v17.09/engine/userguide/networking/default_network/configure-dns/
[user-defined dns link]: https://docs.docker.com/v17.09/engine/userguide/networking/configure-dns/