# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit autotools eutils gnome2 multilib pax-utils python
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="http://live.gnome.org/GnomeShell"

LICENSE="GPL-2"
SLOT="0"
IUSE="+bluetooth +networkmanager systemd"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# latest g-c-c is needed due to https://bugs.gentoo.org/show_bug.cgi?id=360057
# libXfixes-5.0 needed for pointer barriers
# TODO: gstreamer support is currently automagical:
# gstreamer? ( >=media-libs/gstreamer-0.11.92 )
COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.5.3
	>=app-crypt/gcr-3.3.90[introspection]
	>=dev-libs/glib-2.31.6:2
	>=dev-libs/gjs-1.33.2
	>=dev-libs/gobject-introspection-0.10.1
	>=x11-libs/gtk+-3.3.9:3[introspection]
	>=media-libs/clutter-1.9.16:1.0[introspection]
	>=dev-libs/json-glib-0.13.2
	>=dev-libs/libcroco-0.6.2:0.6
	>=gnome-base/gnome-desktop-3.5.1:3
	>=gnome-base/gsettings-desktop-schemas-3.5.4
	>=gnome-base/gnome-keyring-3.3.90
	>=gnome-base/gnome-menus-3.5.3:3[introspection]
	gnome-base/libgnome-keyring
	>=gnome-extra/evolution-data-server-3.5.3
	>=media-libs/gst-plugins-base-0.10.16:0.10
	>=net-im/telepathy-logger-0.2.4[introspection]
	>=net-libs/telepathy-glib-0.17.5[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=x11-libs/libXfixes-5.0
	>=x11-wm/mutter-3.5.90[introspection]
	>=x11-libs/startup-notification-0.11

	dev-libs/dbus-glib
	dev-libs/libxml2:2
	gnome-base/librsvg
	media-libs/libcanberra
	media-libs/mesa
	media-sound/pulseaudio
	net-libs/libsoup:2.4[introspection]
	x11-libs/libX11
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/pango[introspection]
	x11-apps/mesa-progs
	>=app-i18n/ibus-1.4.99.20120712

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.1.0[introspection] )
	networkmanager? ( >=net-misc/networkmanager-0.8.999[introspection] )
	systemd? ( >=sys-apps/systemd-31 )
"
# Runtime-only deps are probably incomplete and approximate.
# Each block:
# 1. Pull in polkit-0.101 for pretty authorization dialogs
# 2. Introspection stuff + dconf needed via imports.gi.*
# 3. gnome-session is needed for gnome-session-quit
# 4. Control shell settings
# 5. accountsservice is needed for GdmUserManager (0.6.14 needed for fast
#    user switching with gdm-3.1.x)
# 6. caribou needed for on-screen keyboard
# 7. xdg-utils needed for xdg-open, used by extension tool
# 8. gnome-icon-theme-symbolic neeed for various icons
# 9. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c
RDEPEND="${COMMON_DEPEND}
	>=sys-auth/polkit-0.101[introspection]

	>=gnome-base/dconf-0.4.1
	>=gnome-base/libgnomekbd-2.91.4[introspection]
	sys-power/upower[introspection]

	>=gnome-base/gnome-session-2.91.91

	>=gnome-base/gnome-settings-daemon-2.91
	>=gnome-base/gnome-control-center-2.91.92-r1[bluetooth(+)?]

	>=sys-apps/accountsservice-0.6.14[introspection]

	>=app-accessibility/caribou-0.3

	x11-misc/xdg-utils

	x11-themes/gnome-icon-theme-symbolic

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )

	!systemd? ( sys-auth/consolekit )
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	virtual/pkgconfig
	!!=dev-lang/spidermonkey-1.8.2*"
# libmozjs.so is picked up from /usr/lib while compiling, so block at build-time
# https://bugs.gentoo.org/show_bug.cgi?id=360413

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	# Don't error out on warnings
	G2CONF="${G2CONF}
		--enable-compile-warnings=maximum
		--disable-schemas-compile
		--disable-jhbuild-wrapper-script
		$(use_with bluetooth)
		$(use_enable networkmanager)
		$(use_with systemd)
		BROWSER_PLUGIN_DIR=${EPREFIX}/usr/$(get_libdir)/nsbrowser/plugins"
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Fix automagic gnome-bluetooth dep, bug #398145
	epatch "${FILESDIR}/${PN}-3.5.x-bluetooth-flag.patch"

	# Make networkmanager optional, bug #398593
	epatch "${FILESDIR}/${PN}-3.5.x-networkmanager-flag.patch"

	[[ ${PV} != 9999 ]] && eautoreconf
	gnome2_src_prepare

	# Drop G_DISABLE_DEPRECATED for sanity on glib upgrades; bug #384765
	# Note: sed Makefile.in because it is generated from several Makefile.ams
	sed -e 's/-DG_DISABLE_DEPRECATED//g' \
		-i src/Makefile.in browser-plugin/Makefile.in || die "sed failed"
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}/usr/bin/gnome-shell-extension-tool"

	# Required for gnome-shell on hardened/PaX, bug #398941
	# Future-proof for >=spidermonkey-1.8.7 following polkit's example
	if has_version '<dev-lang/spidermonkey-1.8.7'; then
		pax-mark mr "${ED}usr/bin/gnome-shell"
	elif has_version '>=dev-lang/spidermonkey-1.8.7[jit]'; then
		pax-mark m "${ED}usr/bin/gnome-shell"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version '>=media-libs/gst-plugins-good-0.10.23' || \
	   ! has_version 'media-plugins/gst-plugins-vp8'; then
		ewarn "To make use of GNOME Shell's built-in screen recording utility,"
		ewarn "you need to either install >=media-libs/gst-plugins-good-0.10.23"
		ewarn "and media-plugins/gst-plugins-vp8, or use dconf-editor to change"
		ewarn "apps.gnome-shell.recorder/pipeline to what you want to use."
	fi

	if ! has_version ">=x11-base/xorg-server-1.11"; then
		ewarn "If you use multiple screens, it is highly recommended that you"
		ewarn "upgrade to >=x11-base/xorg-server-1.11 to be able to make use of"
		ewarn "pointer barriers which will make it easier to use hot corners."
	fi

	if has_version "<x11-drivers/ati-drivers-12"; then
		ewarn "GNOME Shell has been reported to show graphical corruption under"
		ewarn "x11-drivers/ati-drivers-11.*; you may want to use GNOME in"
		ewarn "fallback mode, or switch to open-source drivers."
	fi

	if has_version "media-libs/mesa[video_cards_radeon]" ||
	   has_version "media-libs/mesa[video_cards_r300]" ||
	   has_version "media-libs/mesa[video_cards_r600]"; then
		elog "GNOME Shell is unstable under classic-mode r300/r600 mesa drivers."
		elog "Make sure that gallium architecture for r300 and r600 drivers is"
		elog "selected using 'eselect mesa'."
		if ! has_version "media-libs/mesa[gallium]"; then
			ewarn "You will need to emerge media-libs/mesa with USE=gallium."
		fi
	fi

	if has_version "media-libs/mesa[video_cards_intel]" ||
	   has_version "media-libs/mesa[video_cards_i915]" ||
	   has_version "media-libs/mesa[video_cards_i965]"; then
		elog "GNOME Shell is unstable under gallium-mode i915/i965 mesa drivers."
		elog "Make sure that classic architecture for i915 and i965 drivers is"
		elog "selected using 'eselect mesa'."
		if ! has_version "media-libs/mesa[classic]"; then
			ewarn "You will need to emerge media-libs/mesa with USE=classic."
		fi
	fi
}
