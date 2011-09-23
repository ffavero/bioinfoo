# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#

inherit autotools eutils multilib apache-module


DESCRIPTION="An embedded R interpreter for Apache2"
SRC_URI="http://biostat.mc.vanderbilt.edu/rapache/files/${P}.tar.gz"
HOMEPAGE="http://biostat.mc.vanderbilt.edu/rapache/"
LICENSE="Apache-2.0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SLOT="1"
S="${WORKDIR}/${P}"
DEPEND=">=dev-lang/R-2.5.1
	>=www-servers/apache-2.2.4
	>=www-apache/libapreq2-2.04"
RDEPEND="${DEPEND}"

APACHE_MODULESDIR="/usr/lib/apache2/modules"
APACHE_MODULES_CONFDIR="/etc/apache2/modules.d/"
APACHE2_MOD_CONF="21_mod_r"
APACHE2_MOD_DEFINE="R"
APACHE2_MOD_FILE="${S}/.libs/mod_R.so"

DOCFILES="INSTALL LICENSE README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf || die
}

src_compile() {
	cd "${S}"
	./configure --with-apache2-apxs=/usr/sbin/apxs2 --with-R=/usr/bin/R --with-apreq2-config=/usr/bin/apreq2-config || die
	make || die
}

src_install() {
	
	dodir "${APACHE_MODULESDIR}"
        insinto "${APACHE_MODULESDIR}"
	doins "${APACHE2_MOD_FILE}"

	find "${D}" -name 'mod_r.conf' -delete || die "failed to remove mod_r.conf"
	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${FILESDIR}/${APACHE2_MOD_CONF##*/}.conf" "${APACHE2_MOD_CONF##*/}.conf" \
	 || die "internal ebuild error: '${FILESDIR}/${APACHE2_MOD_CONF}.conf' not found"
	apache-module_src_install

}
pkg_postinst() {
        elog
        elog	"It is possible to set up the module in the /etc/conf.d/apache2"
        elog    " adding the option APACHE2_OPTS=\"-D R\" "
        elog
       	elog	"Add something similar to this to /etc/apache2/httpd.conf:"
	elog	"LoadModule R_module modules/mod_R.so"
        elog
	elog	"Add also:"
	elog	"<Location /RApacheInfo>"
	elog		"SetHandler r-info"
	elog	"</Location>"
	elog	"if you want to display the R status in http://localhost/RApacheInfo"
	elog	"Read the manual at http://biostat.mc.vanderbilt.edu/rapache/manual.html"
	elog 	"for further information"
}

