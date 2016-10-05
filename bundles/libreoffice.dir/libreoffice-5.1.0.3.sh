#!/bin/bash

build_compile()
{
    bandit_mkdir external/tarballs
    ln -sv $BUILD_SOURCES/libreoffice-dictionaries-5.1.0.3.tar.xz  external/tarballs/
    ln -sv $BUILD_SOURCES/libreoffice-help-5.1.0.3.tar.xz          external/tarballs/
    ln -sv $BUILD_SOURCES/libreoffice-translations-5.1.0.3.tar.xz  external/tarballs/

    sed -e "/gzip -f/d"   \
	-e "s|.1.gz|.1|g" \
	-i bin/distro-install-desktop-integration

    sed -e "/distro-install-file-lists/d" -i Makefile.in

    sed -i "s#isnan#std::&#g" xmloff/source/draw/ximp3dscene.cxx

    chmod -v +x bin/unpack-sources

    options=(
	--prefix=$PHY_LO_PREFIX     \
	--sysconfdir=/etc           \
	--with-vendor=phyglos       \
	--with-lang='fr en-GB'      \
	--with-help                 \
	--with-myspell-dicts        \
	--with-alloc=system         \
	--without-java              \
	--without-system-dicts      \
	--disable-dconf             \
	--disable-odk               \
	--enable-release-build=yes  \
	--enable-python=system      \
	--with-system-apr           \
	--with-system-boost=yes     \
	--with-system-cairo         \
	--with-system-curl          \
	--with-system-expat         \
	--with-system-graphite      \
	--with-system-harfbuzz      \
	--with-system-icu           \
	--with-system-jpeg          \
	--with-system-lcms2         \
	--with-system-libatomic_ops \
	--with-system-libpng        \
	--with-system-libxml        \
	--with-system-neon          \
	--with-system-npapi-headers \
	--with-system-nss           \
	--with-system-odbc          \
	--with-system-openldap      \
	--with-system-openssl       \
	--with-system-poppler       \
	--with-system-postgresql    \
	--with-system-redland       \
	--with-system-serf          \
	--with-system-zlib          \
	--with-parallelism=$(getconf _NPROCESSORS_ONLN)
    )

    ACLOCAL=''   \
    ./autogen.sh \
	--prefix=$PHY_LO_PREFIX               \
	--sysconfdir=/etc                     \
	--enable-release-build=yes            \
--enable-split-app-modules                        \
--enable-hardlink-deliver                         \
--disable-dependency-tracking                     \
	--with-vendor=phyglos                 \
	--with-build-version=1.8.a3           \
--with-extra-buildid="phyglos-1.8.a3"             \
	--with-lang="${PHY_LO_LANG}"              \
	--with-help                  \
	--with-alloc=system          \
	--with-myspell-dicts         \
	--without-system-dicts       \
--with-perl-home=/usr                              \
--without-java                \
--without-junit               \
--without-krb5                \
--without-gssapi              \
--with-webdav=no              \
--disable-neon                \
--disable-evolution2                            \
--disable-postgresql-sdbc                       \
--disable-firebird-sdbc                         \
--disable-report-builder                        \
--disable-lpsolve                               \
--disable-coinmp                                \
--disable-pdfimport                             \
--disable-sdremote                              \
--disable-sdremote-bluetooth                    \
--disable-lotuswordpro                          \
--disable-gltf                                  \
--disable-collada                               \
--disable-scripting-beanshell                   \
--disable-scripting-javascript                  \
--disable-avahi                                 \
--disable-graphite                              \
--with-x                                            \
--enable-gtk	                                \
--disable-gtk3	                                \
--disable-gio                                   \
--disable-telepathy                             \
--disable-randr                                 \
--disable-randr-link                            \
	--disable-dconf              \
	--disable-odk                \
	--enable-python=system       \
	--with-system-apr            \
	--with-system-boost=yes      \
	--with-system-cairo          \
	--with-system-clucene        \
	--with-system-curl           \
	--with-system-expat          \
	--with-system-icu            \
	--with-system-harfbuzz       \
	--with-system-jpeg           \
	--with-system-lcms2          \
	--with-system-libatomic_ops  \
--without-system-libcmis                                  \
	--with-system-libpng         \
	--with-system-libxml         \
	--with-system-npapi-headers  \
	--with-system-nss            \
	--with-system-openssl        \
	--with-system-openldap       \
	--with-system-poppler        \
	--with-system-zlib           \
	--with-parallelism=$(getconf _NPROCESSORS_ONLN)

    make build-nocheck
}

build_pack()
{
    make DESTDIR=$BUILD_PACK distro-pack-install

    bandit_mkdir $BUILD_PACK$PHY_LO_PREFIX/share/appdata
    install -v -m644 sysui/desktop/appstream-appdata/*.xml $BUILD_PACK$PHY_LO_PREFIX/share/appdata

    if [ "$PHY_LO_PREFIX" != "/usr" ]; then
	# Binaries
	bandit_mkdir $BUILD_PACK/usr/bin
	ln -svf $PHY_LO_PREFIX/lib/libreoffice/program/soffice $BUILD_PACK/usr/bin/libreoffice

	# Icons
	for d in $BUILD_PACK$PHY_LO_PREFIX/share/icons/*; do
	    for s in ${d}/*; do
		bandit_mkdir $BUILD_PACK/usr/share/icons/$(basename $d)/$(basename $s)/apps
		for i in ${s}/apps/*; do
		    ln -svf ${i#$BUILD_PACK} \
		       $BUILD_PACK/usr/share/icons/$(basename $d)/$(basename $s)/apps/$(basename $i)
		done
	    done
	done

	# Desktop menu entries
	bandit_mkdir $BUILD_PACK/usr/share/applications/
	for i in $BUILD_PACK$PHY_LO_PREFIX/lib/libreoffice/share/xdg/*; do
	    ln -svf ${i#$BUILD_PACK} $BUILD_PACK/usr/share/applications/libreoffice-$(basename $i)
	done

	# Man pages
	bandit_mkdir $BUILD_PACK/usr/share/man/man1/
	for i in $BUILD_PACK$PHY_LO_PREFIX/share/man/man1/*; do
	    ln -svf ${i#$BUILD_PACK} $BUILD_PACK/usr/share/man/man1/
	done
    fi
}

install_setup()
{
    for i in /usr/share/icons/*; do
	gtk-update-icon-cache -qtf $i
    done
   
    update-desktop-database /usr/share/applications
}
