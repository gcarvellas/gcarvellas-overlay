EAPI=8

PLOCALES="en en_US"

inherit git-r3 cmake

DESCRITPION="Fork of StepMania 5.1, improved for the post-ITG community"
HOMEPAGE="https://github.com/itgmania/itgmania"
EGIT_REPO_URI="https://github.com/itgmania/itgmania.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+X +64 +ipo +pie +ffmpeg +glew +jpeg +jsoncpp +mad +ogg +pcre +png +libtomcrypt +libtommath +zlib -clubfantastic"

BDEPEND="
	dev-util/ninja
	dev-util/cmake
	"

# All are from stepmania ci/cd
COMMON_DEPEND="
	ffmpeg? ( media-video/ffmpeg:=[X,alsa,opengl] )
	glew? ( media-libs/glew )
	jsoncpp? ( dev-libs/jsoncpp )
	mad? ( media-libs/libmad )
	png? ( media-libs/libpng:=[64] )
	libtomcrypt? ( media-libs/libtomcrypt )
	libtommath? ( media-libs/libtommath )
	zlib? ( sys-libs/zlib )
	X? ( x11-libs/libX11 x11-libs/libXrandr x11-libs/libXtst )
"

# https://aur.archlinux.org/packages/itgmania-bin
AUR_DEPEND="
	dev-lang/lua
	dev-libs/libusb-compat
	media-libs/harfbuzz
	media-libs/libglvnd
"

# https://github.com/itgmania/itgmania/blob/ce641a7c741eb8168fee006ce59a8c9bf90213b4/.github/workflows/ci.yml
ITGMANIA_CI_CD_DEPEND="
	media-libs/glu
	x11-libs/libXinerama
"

# https://github.com/stepmania/stepmania/blob/5_1-new/.github/workflows/ci.yml
STEPMANIA_CI_CD_DEPEND="
	media-libs/alsa-lib
	media-libs/mesa
	x11-libs/gtk+
	media-sound/jack2
	media-libs/libpulse
	virtual/libudev
	media-libs/libva
	media-libs/libvorbis
	dev-lang/nasm
"

DEPEND="${COMMON_DEPEND}
	${AUR_DEPEND}
	${ITGMANIA_CI_CD_DEPEND}
	${STEPMANIA_CI_CD_DEPEND}
"

src_unpack() {
	git-r3_src_unpack
	default
}

src_compile() {

	default

	DESTDIR="${D}" cmake -G Ninja -S ${PN} -B build \
		-DCMAKE_BUILD_TYPE=None \
		-DCMAKE_C_FLAGS="${CPPFLAGS} ${CFLAGS}" \
		-DCMAKE_CXX_FLAGS="${CPPFLAGS} ${CXXFLAGS}" \
		-DCMAKE_INSTALL_PREFIX="${S}" \
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=$(usex ipo) \
		-DCMAKE_POSITION_INDEPENDENT_CODE=$(usex pie) \
		-DWITH_SYSTEM_FFMPEG=$(usex ffmpeg) \
		-DWITH_SYSTEM_GLEW=$(usex glew) \
		-DWITH_SYSTEM_JPEG=$(usex jpeg) \
		-DWITH_SYSTEM_JSONCPP=$(usex jsoncpp) \
		-DWITH_SYSTEM_MAD=$(usex mad) \
		-DWITH_SYSTEM_OGG=$(usex ogg) \
		-DWITH_SYSTEM_PCRE=$(usex pcre) \
		-DWITH_SYSTEM_PNG=$(usex png) \
		-DWITH_SYSTEM_TOMCRYPT=$(usex libtomcrypt) \
		-DWITH_SYSTEM_TOMMATH=$(usex libtommath) \
		-DWITH_SYSTEM_ZLIB=$(usex zlib) \
		-DWITH_CLUB_FANTASTIC=$(usex clubfantastic) \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_OSX_ARCHITECTURES=x86_64 \
		-DBUILD_TAG="linux-x64"
		-DBUILD_64=ON
		-DWITH_FULL_RELEASE=On
		-Wno-dev
	DESTDIR="${D}" cmake --build build

}

src_install() {
	dobin ${D}/itgmania
	dodoc ${S}/README.md
}
