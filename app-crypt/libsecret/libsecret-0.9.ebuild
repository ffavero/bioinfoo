# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-3.4.2.3.ebuild,v 1.1 2012/08/09 09:01:38 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit gnome2 python

DESCRIPTION="Library for storing and retriving password and other secrets."
HOMEPAGE="http://live.gnome.org/Libsecret"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86 ~x86-linux"

# libgee extensively used in libempathy
# gdk-pixbuf and pango extensively used in libempathy-gtk
# clutter-1.10 dep is missing in configure, newer API is used
# folks-0.6.8 is needed to load the contacts list, configure is wrong again
COMMON_DEPEND=">=dev-libs/glib-2.31:2
	>=dev-libs/gobject-introspection-1.33
"
# FIXME: gst-plugins-bad is required for the valve plugin. This should move to good
# eventually at which point the dep can be dropped
# empathy-3.4 is incompatible with telepathy-rakia-0.6, bug #403861
RDEPEND="${COMMON_DEPEND}
"
DEPEND="${COMMON_DEPEND}
"
PDEPEND=""

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}"
}

pkg_postinst() {
	gnome2_pkg_postinst
}
