EAPI=8

DESCRIPTION="Control the brightness of backlight and keyboard LED devices on Linux."
HOMEPAGE="https://gitlab.com/cameronnemo/brillo"
SRC_URI="https://gitlab.com/cameronnemo/brillo/-/archive/v1.4.12/brillo-v1.4.12.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	dev-go/go-md2man
"

S="${WORKDIR}/${PN}-v${PV}"

pkg_postinst() {
	elog "You will need to add your user to the 'video' group"
}

