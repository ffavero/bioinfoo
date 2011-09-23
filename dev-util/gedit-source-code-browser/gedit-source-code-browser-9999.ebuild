# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit python eutils git

DESCRIPTION="Ctags plugins for gedit"
HOMEPAGE="http://live.gnome.org/GeditPlugins"
EGIT_REPO_URI="git://github.com/Quixotix/${PN}.git"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND=">=app-editors/gedit-3.0.0
         dev-util/ctags"
DEPEND="${RDEPEND}"


S="${WORKDIR}"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
        cd ${S}

	insinto /usr/share/glib-2.0/schemas
	doins sourcecodebrowser/data/org.gnome.gedit.plugins.sourcecodebrowser.gschema.xml

	insinto /usr/$(get_libdir)/gedit/plugins
	doins -r sourcecodebrowser
	doins sourcecodebrowser.plugin
}

pkg_postinst() {
        glib-compile-schemas /usr/share/glib-2.0/schemas/
	python_need_rebuild
	python_mod_optimize /usr/$(get_libdir)/gedit/plugins
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/gedit/plugins
}
