# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no" # --disable-debug disables all assertions
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Nautilus extension for convert audio file from/to various extensions"
HOMEPAGE="http://code.google.com/p/nautilus-sound-converter"

LICENSE="GPL-2"
SLOT="0"
#if [[ ${PV} = 9999 ]]; then
#	KEYWORDS=""
#else
	KEYWORDS="~amd64 ~x86"
#fi
IUSE=""

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.35
	>=dev-libs/glib-2.18:2
        media-libs/gstreamer:0.10
	gnome-base/gconf:2
	gnome-base/gnome-keyring
	>=gnome-base/nautilus-3
	x11-libs/gtk+:3"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

pkg_setup() {
	DOCS="AUTHORS NEWS README" # ChangeLog is not used
	G2CONF="${G2CONF}"
}

src_prepare() {
	gnome2_src_prepare
	# Do not let configure mangle CFLAGS
	sed -e '/^[ \t]*CFLAGS="$CFLAGS \(-g\|-O0\)/d' -i configure.ac configure ||
		die "sed failed"
}
