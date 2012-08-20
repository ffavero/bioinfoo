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

IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.31.10
	>=x11-libs/gtk+-3.4.0:3"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

pkg_setup() {
	G2CONF="${G2CONF}
                VALAC=$(type -P valac-0.16)"
	DOCS="AUTHORS ChangeLog NEWS README"
}
