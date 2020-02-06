set -x

COMMON_OPTS="\
--with-pdumper=yes \
--with-unexec=no \
--with-dumping=pdumper \
--with-png \
--with-jpeg \
--with-tiff \
--with-gif \
--with-rsvg \
--with-modules \
--with-cairo  \
--with-dbus=no \
--with-gconf=no \
--with-gsettings=no"


if [ "$(uname)" == "Darwin" ]
then

    SYSTEM_OPTS="${COMMON_OPTS}"
    # The build has a hard time finding libtinfo, which is separated from
    # libncurses. See
    # https://github.com/conda-forge/emacs-feedstock/pull/16#issuecomment-334241528
    export LDFLAGS="${LDFLAGS} -ltinfo"

else

    SYSTEM_OPTS="\
--with-x-toolkit=lucid \
--x-includes=$PREFIX/include \
--x-libraries=$PREFIX/lib"

fi

./autogen.sh
./configure --prefix="$PREFIX" $COMMON_OPTS $SYSTEM_OPTS

make
# make check
make install

if [ "$(uname)" == "Darwin" ]
then
    mv nextstep/Emacs.app $PREFIX/Emacs.app
    mkdir -p $PREFIX/bin
    cat <<EOF > $PREFIX/bin/emacs-$PKG_VERSION
#!/bin/sh
"$PREFIX/Emacs.app/Contents/MacOS/Emacs" "\$@"
EOF
    chmod a+x $PREFIX/bin/emacs-$PKG_VERSION
    ln -s $PREFIX/bin/emacs-$PKG_VERSION $PREFIX/bin/emacs
    ln -s $PREFIX/Emacs.app/Contents/MacOS/bin/ctags $PREFIX/bin/ctags
    ln -s $PREFIX/Emacs.app/Contents/MacOS/bin/ebrowse $PREFIX/bin/ebrowse
    ln -s $PREFIX/Emacs.app/Contents/MacOS/bin/emacsclient $PREFIX/bin/emacsclient
    ln -s $PREFIX/Emacs.app/Contents/MacOS/bin/etags $PREFIX/bin/etags
fi
