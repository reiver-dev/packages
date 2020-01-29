set -x

export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

./autogen.sh
./configure --prefix="${PREFIX}" \
            --with-ncurses \
            --with-curses="$PREFIX" \
            --with-crypto-library=openssl

make -j"${CPU_COUNT}"
make install
