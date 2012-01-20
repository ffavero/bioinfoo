# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.30.2.ebuild,v 1.1 2010/06/13 19:34:52 pacho Exp $

EAPI="3"
PYTHON_DEPEND="2"


inherit  gnome2-utils

DESCRIPTION="Smart highlighing plugin for gedit"
HOMEPAGE="http://code.google.com/p/smart-highlighting-gedit"
SRC_URI="http://smart-highlighting-gedit.googlecode.com/files/smart_highlighting-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"

RDEPEND="
        >=app-editors/gedit-3.1.0
        >=dev-libs/gobject-introspection-1.28
	"

DEPEND="${RDEPEND}"

PLUGINS="/usr/lib/gedit/plugins/"

src_configure() {
        :
}

src_compile()   {
        :
}

src_install()   {

   cd ${WORKDIR}/smart_highlighting-${PV}
   dodir   ${PLUGINS}  || die
   cp -rv   smart_highlight* ${D}${PLUGINS} || die
}
