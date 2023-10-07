FROM kalilinux/kali-rolling:latest as build

ARG DEBIAN_FRONTEND=noninteractive

    #afl++                          \
RUN apt update                        \
&&  apt full-upgrade -y               \
    --no-install-recommends           \
&&  apt install      -y               \
    --no-install-recommends           \
    ccache                            \
    clang                             \
    clang-13                          \
    clang-14                          \
    clang-15                          \
    clang-16                          \
    distcc-pump                       \
    gcc                               \
    gcc-11                            \
    gcc-12                            \
    gcc-13                            \
    gcc-multilib                      \
    gcc-11-multilib                   \
    gcc-12-multilib                   \
    gcc-13-multilib                   \
    g++                               \
    g++-11                            \
    g++-12                            \
    g++-13                            \
    libc-dev                          \
    libisl-dev                        \
    llvm-13                           \
    llvm-14                           \
    llvm-15                           \
&&  update-ccache-symlinks            \
&&  update-distcc-symlinks            \
&&  apt autoremove   -y               \
    --purge                           \
&&  apt clean        -y               \
&&  rm -rf /var/lib/apt/lists/*       \
&&  find /usr/lib/ccache              \
    -mindepth 1                       \
 \! -type d                           \
|   tee -a /etc/distcc/commands.allow \
|   xargs ls -l                       \
&&  command -v ccache                 \
&&  command -v distcc

#RUN for k in                         \
#    afl-c++                          \
#    afl-cc                           \
#    afl-clang                        \
#    afl-clang++                      \
#    afl-clang-fast                   \
#    afl-clang-fast++                 \
#    afl-clang-lto                    \
#    afl-clang-lto++                  \
#    afl-g++                          \
#    afl-gcc                          \
#    afl-gcc-fast                     \
#    afl-g++-fast                   ; \
#do  ln -sv                           \
#        ../../bin/ccache             \
#         /usr/lib/ccache/$k          \
#||  exit 2                         ; \
#    done                             \

ENV CCACHE_CONFIGPATH       /etc/ccache.conf.d/ccache.conf
VOLUME                    ["/etc/ccache.conf.d"]
ENV CCACHE_DIR              /var/cache/ccache
VOLUME                    ["/var/cache/ccache"]
#ENV CCACHE_PREFIX           distcc

#RUN ln -fsv                          \
#    /etc/ccache.conf.d/ccache.conf   \
#    /etc/ccache.conf

#RUN adduser --system distcc-user

ENV DISTCC_CMDLIST          /etc/distcc/commands.allow
ENV DISTCC_CMDLIST_NUMWORDS=1
ENV PATH                   "/usr/lib/ccache:$PATH"

COPY        ./entrypoint.sh \
             /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT [                       \
#  "/usr/bin/distccd",              \
#  "--daemon",                      \
#  "--log-stderr",                  \
#  "--no-detach",                   \
#  "--user",       "distccd"        \
#]
#
#CMD [                              \
#  "--allow",      "0.0.0.0/0",     \
#  "--listen",     "0.0.0.0",       \
#  "--log-level=debug",             \
#  "--nice",       "10",            \
#  "--port",       "3632",          \
#  "--stats",                       \
#  "--stats-port", "3633"           \
#]

EXPOSE 3632/tcp \
       3633/tcp

#HEALTHCHECK --interval=5m          \
#            --timeout=3s           \
#CMD         curl -f                \
#            http://0.0.0.0:3633/   \
#||          exit 1

