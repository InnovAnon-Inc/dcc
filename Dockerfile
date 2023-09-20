FROM voidlinux/voidlinux-musl as build

ARG DEBIAN_FRONTEND=noninteractive

RUN echo repository=https://repo-fastly.voidlinux.org/current/musl/nonfree > /etc/xbps.d/10-repository-nonfree.conf
RUN xbps-install -Sy \
    xbps             \
&&  xbps-install -Sy \
    ccache           \
    clang            \
    distcc           \
    distcc-pump      \
    gcc              \
    isl-devel

RUN find /usr/lib/ccache             \
    -mindepth 1                      \
 \! -type d                          \
|   tee -a /etc/distcc/commands.allow \
|   xargs ls -l

RUN ln -fsv                          \
    /etc/ccache.conf.d/ccache.conf   \
    /etc/ccache.conf

RUN useradd --system distccd

ENV DISTCC_CMDLIST /etc/distcc/commands.allow
#ENV DISTCC_CMDLIST_NUMWORDS=2
ENV DISTCC_CMDLIST_NUMWORDS=1
# TODO remove this ?
ENV PATH          "/usr/lib/ccache:$PATH"
ENV PATH          "/usr/lib/ccache/bin:$PATH"

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT [                       \
#  "/usr/sbin/distccd",             \
#  "--daemon",                      \
#  "--log-stderr",                  \
#  "--no-detach",                   \
#  "--user",       "distcc-user"    \
#]
#
#CMD [                              \
#  "--allow",      "0.0.0.0/0",     \
#  "--listen",     "0.0.0.0",       \
#  "--log-level=info",              \
#  "--nice",       "10",            \
#  "--port",       "3632",          \
#  "--stats",                       \
#  "--stats-port", "3633"           \
#]

VOLUME ["/etc/ccache.conf.d"]
VOLUME ["/var/cache/ccache"]

EXPOSE 3632/tcp \
       3633/tcp

#HEALTHCHECK --interval=5m          \
#            --timeout=3s           \
#CMD         curl -f                \
#            http://0.0.0.0:3639/   \
#||          exit 1

