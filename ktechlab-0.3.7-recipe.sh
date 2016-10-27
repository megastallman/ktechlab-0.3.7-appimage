#!/bin/bash

# Install build deps if needed
#sudo apt install build-essential rsync

PROJDIR=$PWD

if [ ! $(ls | grep AppImageAssistant*AppImage) ]; then 
	echo "Please copy the AppImageAssistant_X-x86_64.AppImage file here"
	exit 1
fi

# Actually build Ktechlab from sources
if [ ! -f /tmp/qt3builddir/bin/ktechlab ]; then
	./ktechlab-build.sh
fi

if [ ! -f /tmp/qt3builddir/bin/designer ]; then
	echo "ERROR: QT3 is not built!"
	exit 1
fi

if [ ! -f /tmp/qt3builddir/bin/ktechlab ]; then
	echo "ERROR: Ktechlab is not built!"
	exit 1
fi

cd $PROJDIR

rm ktechlab0.3.7.AppImage || true
rm -rf ktechlab0.3.7.AppDir || true
mkdir -p ktechlab0.3.7.AppDir && cd ktechlab0.3.7.AppDir
cp ../AppRun . && chmod +x AppRun
cp ../ktechlab.png .
cp ../ktechlab.desktop .
cp ../VERSION .

mkdir qt3
rsync -av /tmp/qt3builddir/ qt3/ --exclude=doc --exclude=src --exclude=man --exclude=phrasebooks --exclude=mkspecs --exclude=include --exclude=translations --exclude=templates

wget https://raw.githubusercontent.com/proot-me/proot-static-build/master/static/proot-x86_64
chmod +x proot-x86_64

cd $PROJDIR
chmod +x AppImageAssistant* 
./AppImageAssistant* ktechlab0.3.7.AppDir ktechlab0.3.7.AppImage
