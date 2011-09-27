# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EANT_ANT_TASKS="jakarta-regexp-1.4 batik-1.7 xalan xsdlib relaxng-datatype jaxb-2"
EANT_GENTOO_CLASSPATH="swing-layout-1,stax-ex,xmlstreambuffer,sjsxp,concurrent-util,jsr173,jsr181,jsr250,fastinfoset,junit,batik-1.7,freehep-graphicsio-svg,freehep-util,freehep-xml,freehep-export,freehep-graphicsio,freehep-graphicsio-java,freehep-swing,freehep-graphicsio-ps,freehep-io,freehep-graphics2d,freehep-misc-deps,itext,piccolo2d,tclib"
JAVA_ANT_REWRITE_CLASSPATH="true"

inherit versionator java-pkg-2 java-ant-2 eutils

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="A visualization platform for molecular interaction networks"
HOMEPAGE="http://www.cytoscape.org/"
#SRC_URI="http://chianti.ucsd.edu/Cyto-2_8-beta/cytoscape-2.8.0-beta2.tar.gz"
SRC_URI="http://chianti.ucsd.edu/Cyto-${MY_PV}/cytoscape-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86" 
DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

#S="${WORKDIR}/${PN}-2.8.0-beta2"

src_install() {
	java-pkg_dojar cytoscape.jar
	java-pkg_jarinto /usr/share/${PN}/plugins
	java-pkg_dojar plugins/*.jar

	insinto /usr/share/${PN}
	
	# replacement for resources/bin/cytoscape.sh
	java-pkg_dolauncher cytoscape.sh --main cytoscape.CyMain \
		--java_args '-Dswing.aatext=true -Dawt.useSystemAAFontSettings=lcd -Xss10M -Xmx2000M' \
		--pkg_args '-p '/usr/share/${PN}/plugins' \"$@\"'

	dodoc docs/manual.pdf
}
