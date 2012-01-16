# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

EGIT_REPO_URI="git://github.com/seiflotfy/gnome-shell-zeitgeist-extension"

inherit  gnome2-utils git

DESCRIPTION="Zeitgeist extensions for GNOME Shell"
HOMEPAGE="https://github.com/seiflotfy/gnome-shell-zeitgeist-extension"

LICENSE="GPL-2"
SLOT="0"
IUSE="+hugo +journal +jump-list +search +smart-launcher"
KEYWORDS="~amd64 ~x86"

EXTENSIONS="/usr/share/gnome-shell/extensions"

COMMON_DEPEND="
        >=dev-libs/glib-2.30
        >=gnome-base/gnome-desktop-3:3"
RDEPEND="${COMMON_DEPEND}
        gnome-base/gnome-desktop:3[introspection]
        media-libs/clutter:1.0[introspection]
        net-libs/telepathy-glib[introspection]
        x11-libs/gtk+:3[introspection]
        x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
        >=gnome-extra/zeitgeist-0.8[fts]
        >=gnome-extra/zeitgeist-datahub-0.7
        sys-devel/gettext
        >=dev-util/pkgconfig-0.22
        >=dev-util/intltool-0.26
        gnome-base/gnome-common"

src_configure() {
        :
}

src_compile()   {
        :
}

src_install()   {

	if use hugo; then
		insinto ${EXTENSIONS}
        	doins -r hugo@gnome-shell-extensions.zeitgeist-project.com
	fi

	if use journal; then
		insinto ${EXTENSIONS}
        	doins -r journal@gnome-shell-extensions.zeitgeist-project.com
	fi

	if use jump-list; then
		insinto ${EXTENSIONS}
        	doins -r jump-lists@gnome-shell-extensions.zeitgeist-project.com
	fi

	if use search; then
		insinto ${EXTENSIONS}
        	doins -r zeitgeist-search@gnome-shell-extensions.gnome.org
	fi
	if use smart-launcher; then
		insinto ${EXTENSIONS}
        	doins -r smart-launcher@gnome-shell-extensions.zeitgeist-project.com
	fi
}

pkg_preinst() {
        gnome2_schemas_savelist
}

pkg_postinst() {
        gnome2_schemas_update
}

pkg_postrm() {
        gnome2_schemas_update --uninstall
}

