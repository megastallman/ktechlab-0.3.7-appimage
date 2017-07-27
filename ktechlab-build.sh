#!/bin/bash

TARBALLS="http://pkgs.fedoraproject.org/repo/pkgs/qt/qt-x11-free-3.3.8b.tar.gz/9f05b4125cfe477cc52c9742c3c09009/qt-x11-free-3.3.8b.tar.gz
https://sourceforge.net/projects/ktechlab/files/ktechlab/0.3.7/ktechlab-0.3.7.tar.bz2
http://www.ijg.org/files/jpegsrc.v6b.tar.gz
https://sourceforge.net/projects/libpng/files/libpng16/older-releases/1.6.9/libpng-1.6.9.tar.xz
http://downloads.sourceforge.net/libmng/libmng-2.0.2.tar.xz
http://zlib.net/zlib-1.2.8.tar.xz
http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/extra/source/kde3-compat/kdelibs3/kdelibs-3.5.10.tar.bz2"
export PREFIX="/tmp/qt3"
export PROJDIR=$PWD
export LANG="C"
export PATH="$PREFIX/bin:$PATH"
export QT_PLUGIN_PATH="$PREFIX/lib64/kde3/plugins/"
export SRC="$PREFIX/src"
export MANPATH="$PREFIX/man"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PREFIX/lib:$PREFIX/src/qt-x11-free-3.3.8b/lib"

mkdir -p "$PREFIX" || true

if [ ! -d "$SRC" ]; then
	mkdir $SRC || true && cd $SRC
	for TARBALL in $TARBALLS
		do
			wget --retry-connrefused --waitretry=5 -c $TARBALL
		done
		find . -name '*.tar.*' -exec tar -xf {} \;
	fi

mkdir -p $MANPATH/man1 || true

echo "BUILDING LIBMNG =========================================="
cd $SRC/libmng-2.0.2
sed -i "s:#include <jpeg:#include <stdio.h>\n&:" libmng_types.h
./configure --prefix=$PREFIX --disable-static
make 
make install

echo "BUILDING ZLIB ============================================"
cd $SRC/zlib-1.2.8
./configure --prefix=$PREFIX --shared
make
make install

echo "BUILDING LIBPNG =========================================="
cd $SRC/libpng-1.6.9
./configure --prefix=$PREFIX
make
make install

echo "BUILDING JPEG ============================================"
cd $SRC/jpeg-6b
cp $PROJDIR/config.sub .
./configure --prefix=$PREFIX --enable-static --enable-shared
make
make install 

echo "BUILDING QT3 ============================================="
cd $SRC/qt-x11-free-3.3.8b
echo yes | ./configure -prefix $PREFIX -thread -shared -fast -no-exceptions -platform linux-g++ -no-pch -stl -sm -xshape -xinerama -xcursor -xrandr -xrender -xft -tablet -xkb -system-zlib -system-libpng -system-libmng -system-libjpeg -enable-opengl -dlopen-opengl -qt-gif -qt-imgfmt-png -qt-imgfmt-jpeg -plugin-imgfmt-mng -I/usr/include/freetype2 -lfontconfig -L/usr/lib/x86_64-linux-gnu
sed -i s/ptrdiff_t/std::ptrdiff_t/g include/qmap.h
sed -i s/ptrdiff_t/std::ptrdiff_t/g include/qvaluelist.h
sed -i s/ptrdiff_t/std::ptrdiff_t/g include/qvaluevector.h
sed -i s/ptrdiff_t/std::ptrdiff_t/g src/tools/qvaluelist.h
sed -i s/ptrdiff_t/std::ptrdiff_t/g src/tools/qmap.h
make
make install

echo "BUILDING KDELIBS =========================================="
cd $SRC/kdelibs-3.5.10
./configure --prefix=$PREFIX/ --disable-dnssd --disable-cups --disable-pcre --disable-libfam --with-extra-includes=$PREFIX/include/ --with-extra-libs=$PREFIX/lib/ --with-qt-dir=$PREFIX/ --with-qt-includes=$PREFIX/include/ --with-qt-libraries=$PREFIX/lib/ --without-arts --without-lua --with-libthai=no --without-ssl --without-alsa
cd kio/kio
patch < $PROJDIR/kdirwatch.cpp.patch
cd ../..
cd kioslave/ftp
patch < $PROJDIR/ftp.cc.patch
cd ../..
cd kate/part
patch < $PROJDIR/katehighlight.cpp.patch
cd ../..
make
make install

echo "BUILDING KTECHLAB =========================================="
cd $SRC/ktechlab-0.3.7
./configure --prefix=$PREFIX/ --with-extra-libs=$PREFIX/lib/kde3 --with-qt-dir=$PREFIX/ --with-qt-includes=$PREFIX/include/ --with-qt-libraries=$PREFIX/lib/ --without-arts
cd src/electronics/components
patch < $PROJDIR/ecsubcircuit.cpp.patch
patch < $PROJDIR/discretelogic.cpp.patch
cd ../../..
cd src/gui/itemeditor
patch < $PROJDIR/orientationwidget.cpp.patch
cd ../../..
cd src
patch < $PROJDIR/picitem.cpp.patch
cd ..
make
make install

cd $PROJDIR
