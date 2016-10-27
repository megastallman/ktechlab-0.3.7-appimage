# ktechlab-0.3.7-appimage
This repo contains thee old qt3-based ktechlab builds. An /opt-preffixed and an AppImage rootless binary. You can rebuild Ktechlab on your host if needed, so I've included the build recipes.

At the moment, the Ktechlab's authors are currently porting it to kde4/5/KFrameworks, so we've got to use the last stable version. But it'built on top of QT3, and Kdelibs3, but I've got some expertize to build it in a separate prefix, which does not mix with that modern distro file hierarchy I use.

The most sane build defaults are:
 - /opt/qt3 prefix - for usage with installing.
 - /tmp/qt3builddir - for a standalone portable AppImage usage. Root faking is done with proot.

You've got 5 ways of using ktechlab:
 - Just download ktechlab0.3.7.AppImage, chmod +x and run(RECOMMENDED).
 - Use an ubuntu 10.04 chroot, as https://github.com/edivaldo-amaral suggests here: https://github.com/edivaldo-amaral/ktechlab-chroot
 - My old /opt-preffixed tarball should be extracted to /opt. It is located at the "old_deprecated_build" directory. It has also an AppImage build.
 - Rebuild the preffixed installation with ./ktechlab-build.sh(requires changing the $PREFIX variable to the one you like, RECOMMENDED).
 - Rebuild my new AppImage with ./ktechlab-0.3.7-recipe.sh (Don't change the $PREFIX variable).

