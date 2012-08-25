# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-control-center/gnome-control-center-2.32.1.ebuild,v 1.1 2010/12/04 00:46:57 pacho Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # gmodule is used, which uses dlopen

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME Desktop Configuration Tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="2"
IUSE="+cheese +cups +networkmanager +socialweb"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

# XXX: gnome-desktop-2.91.5 is needed for upstream commit c67f7efb
# XXX: NetworkManager-0.9 support is automagic, make hard-dep once it's released
#
# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# Latest gsettings-desktop-schemas is neededfor commit 73f9bffb
# gnome-settings-daemon-3.1.4 is needed for power panel (commit 4f08a325)
COMMON_DEPEND="
	>=dev-libs/glib-2.31.0:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.5.8:3
	>=gnome-base/gsettings-desktop-schemas-3.5.5
	>=gnome-base/gconf-2.0:2
	>=dev-libs/dbus-glib-0.73
	>=gnome-base/gnome-desktop-3.5.6:3
	>=gnome-base/gnome-settings-daemon-3.5.2
	>=gnome-base/libgnomekbd-2.91.91
	>=media-libs/clutter-1.11.3

	app-text/iso-codes
	dev-libs/libpwquality
	dev-libs/libxml2:2
	gnome-base/gnome-menus:3
	gnome-base/libgtop:2
	media-libs/fontconfig
	>=net-libs/gnome-online-accounts-3.5.90

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-0.9.16[glib]
	>=sys-auth/polkit-0.103
	>=sys-power/upower-0.9.1
	>=x11-libs/libnotify-0.7.3
	>=x11-misc/colord-0.1.8

	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.1
	>=x11-libs/libXi-1.2

	cheese? (
		media-libs/gstreamer:0.10
		>=media-video/cheese-2.91.91.1 )
	cups? ( >=net-print/cups-1.4[dbus] )
	networkmanager? (
		>=gnome-extra/nm-applet-0.9.1.90
		>=net-misc/networkmanager-0.8.997 )
	socialweb? ( net-libs/libsocialweb )"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
RDEPEND="${COMMON_DEPEND}
	app-admin/apg
	sys-apps/accountsservice
	cups? ( net-print/cups-pk-helper )

	!<gnome-extra/gnome-color-manager-3.1.2
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<gnome-base/gdm-2.91.94"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40.1
	>=dev-util/pkgconfig-0.19

	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.10.1

	cups? ( sys-apps/sed )"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
        echo 'prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include
extensiondir=${exec_prefix}/lib/control-center-1/panels

Name: libgnome-control-center
Description: A library to create GNOME Control Center extensions
Version: 3.2.0
Requires: glib-2.0 gio-2.0 gtk+-3.0
Libs: -L${libdir} -lgnome-control-center
Cflags: -I${includedir}/gnome-control-center-1' > libgnome-control-center.pc

}

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-static
		$(use_with cheese)
		$(use_enable cups)
		$(use_with socialweb libsocialweb)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_install() {
        dodir   /usr/include/gnome-control-center-1/
        dodir   /usr/include/gnome-control-center-1/libgnome-control-center/
        insinto /usr/include/gnome-control-center-1/libgnome-control-center/
        doins   libgnome-control-center/cc-panel.h || die
        doins   libgnome-control-center/cc-shell.h || die

        insinto /usr/share/pkgconfig/
        doins   libgnome-control-center.pc

        gnome2_src_install
}
