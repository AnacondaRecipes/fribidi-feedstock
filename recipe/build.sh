#!/usr/bin/env bash
set -euo pipefail
set -x

meson builddir \
    --prefix="${PREFIX}" \
    -Ddefault_library=shared \
    -Ddocs=false \
    ${MESON_ARGS:-}

cd builddir
ninja
ninja install

# stuff gets installed into lib64 when we only use lib for conda
if [[ "$(uname -s)" =~ .*Linux.* ]]; then
    mkdir -p $PREFIX/lib
    if [[ -d $PREFIX/lib64 ]]; then
        mv -f $PREFIX/lib64/* $PREFIX/lib
        rm -rf $PREFIX/lib64
    fi
fi
