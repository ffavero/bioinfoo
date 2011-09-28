# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.30.2.ebuild,v 1.1 2010/06/13 19:34:52 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_DEPEND="2"

inherit gnome2 python eutils virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="LaTeX plugin for gedit"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
fi

# X libs are not needed for OSX (aqua)
RDEPEND="
        >=app-editors/gedit-3.1.0
        app-text/texlive
	"

DEPEND="${RDEPEND}"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}"
}

src_prepare() {
        ./autogen.sh
	gnome2_src_prepare

	# disable pyc compiling
	for d in . build-aux ; do
		ln -sfn $(type -P true) "${d}/py-compile"
	done
}

src_test() {
	emake check || die "make check failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_need_rebuild
	python_mod_optimize /usr/$(get_libdir)/gedit/plugins
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/gedit/plugins
}

