# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"

EGIT_REPO_URI="git://github.com/charkins/gnome-shell-extension-notesearch"

inherit gnome2-utils gnome2-live python

DESCRIPTION="Gnote/Tomboy note search provider for GNOME Shell"
HOMEPAGE="https://github.com/charkins/gnome-shell-extension-notesearch"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.30
	>=gnome-base/gnome-desktop-3:3
	app-admin/eselect-gnome-shell-extensions
        >=app-misc/gnote-0.8.2"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	>=gnome-base/gnome-shell-3.2
	>=gnome-extra/gnome-shell-extensions-3.2
        gnome-base/dconf
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

src_prepare() {
        ./autogen.sh --prefix=/usr
}

src_compile() {
	emake
}

src_install()	{
        emake install DESTDIR="${D}" 
}

pkg_postinst() {
	gnome2_pkg_postinst

	einfo "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, you can use the org.gnome.shell disabled-extensions"
	elog "gsettings key to change the disabled extension list per-user."
	elog
}
