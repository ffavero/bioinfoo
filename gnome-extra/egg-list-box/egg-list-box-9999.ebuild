# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="4"
GCONF_DEBUG="no"

inherit eutils gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Egg List Box"
HOMEPAGE="none"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="test"

# FIXME: Interactive testsuite (upstream ? I'm so...pessimistic)
RESTRICT="test"

# Need gtk+-3.3.8 for bug #416039
COMMON_DEPEND=">=dev-libs/glib-2.31.10
	>=x11-libs/gtk+-3.4.0:3"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

# docbook-sgml-utils and docbook-sgml-dtd-4.1 used for creating man pages
# (files under ${S}/man).
# docbook-xml-dtd-4.4 and -4.1.2 are used by the xml files under ${S}/docs.

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable test tests)
		--disable-strict
		--enable-compile-warnings=minimum
		--disable-schemas-compile"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	gnome2_src_prepare

	# Drop debugger CFLAGS from configure
	# XXX: touch configure.ac only if running eautoreconf, otherwise
	# maintainer mode gets triggered -- even if the order is correct
	sed -e 's:^CPPFLAGS="$CPPFLAGS -g"$::g' \
		-i configure || die "debugger sed failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}
