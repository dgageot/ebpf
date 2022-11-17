#!/usr/bin/env sh

set -e

echo "process: $1"
echo "duration: $2s"
pid="$(pgrep $1)"
echo "pid: $pid"
if [ -z "$pid" ]; then
    exit 1
fi
echo "capturing..."
profile -adf -p $pid $2 | tee profile
/flame/FlameGraph/flamegraph.pl < profile --colors java --hash | tee /out/flame.svg
