#! /bin/sh
( ! $UID )

chown distccd:nogroup /var/cache/ccache

/usr/bin/distccd                \
  --daemon                      \
  --log-stderr                  \
  --no-detach                   \
  --user              distccd   \
  --allow             0.0.0.0/0 \
  --listen            0.0.0.0   \
  --log-level=info              \
  --nice                   10   \
  --port                 3632   \
  --stats                       \
  --stats-port           3633

