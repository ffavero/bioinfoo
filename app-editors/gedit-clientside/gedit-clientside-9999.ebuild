# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.30.2.ebuild,v 1.1 2010/06/13 19:34:52 pacho Exp $

EAPI="3"
PYTHON_DEPEND="2"

EGIT_REPO_URI="git://github.com/trentrichardson/Gedit-Clientside-Plugin.git"

inherit  gnome2-utils git

DESCRIPTION="Gedit plugin to develop JS and CSS"
HOMEPAGE="https://github.com/nemec/gedit-git-plugin"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"

RDEPEND="
	net-libs/nodejs
        >=app-editors/gedit-3.1.0
	"

DEPEND="${RDEPEND}"

PLUGINS="/usr/lib/gedit/plugins"

src_configure() {
        :
}

src_compile()   {
        :
}

src_install()   {

   dodir   ${PLUGINS} || die
   insinto ${PLUGINS} 
   doins   clientside.plugin || die
   cp -rv  clientside ${D}${PLUGINS} || die

}
