EAPI=8

PLOCALES="en en_US"

inherit git-r3 cmake

DESCRITPION="Fork of StepMania 5.1, improved for the post-ITG community"
HOMEPAGE="https://github.com/itgmania/itgmania"
EGIT_REPO_URI="https://github.com/itgmania/itgmania.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+ipo +pie +ffmpeg +glew +jpeg +jsoncpp +mad +ogg +pcre +png +libtomcrypt +libtommath +zlib -clubfantastic"

REQUIRED_USE="
	media-libs/glu? ( -32 64 )
	gentoo/libusb-compat? ( -32 64 )
	media-libs/libvorbis? ( -32 64 )
	media-libs/mesa? ( -32 64 vaapi )
"

BDEPEND="dev-util/ninja"

COMMON_DEPEND="
	ffmpeg? ( media-video/ffmpeg:=[X,alsa,opengl] )
	glew? ( media-libs/glew )
	jsoncpp? ( dev-libs/jsoncpp )
	mad? ( media-libs/libmad )
	png? ( media-libs/libpng:=[-32,64] )
	libtomcrypt? ( media-libs/libtomcrypt )
	libtommath? ( media-libs/libtommath )
	zlib? ( sys-libs/zlib )
"

DEPEND="${COMMON_DEPEND}
	dev-util/cmake
	media-video/ffmpeg
	media-libs/glu
	x11-libs/gtk+
	dev-lang/lua
	dev-libs/libusb-compat
	media-libs/harfbuzz
	media-libs/libvorbis
	media-libs/mesa
	dev-python/pkgconfig
	dev-lang/yasm
	media-plugins/alsa-plugins
	media-libs/libglvnd
	media-sound/jack2
	media-libs/libpulse
	virtual/libudev
	media-libs/libva
	media-libs/libvorbis
"

src_unpack() {
	git-r3_src_unpack
	default
}

src_compile() {

	default

	DESTDIR="${D}" cmake -G Ninja -S ${PN} -B build \
		-DCMAKE_BUILD_TYPE=None \
		-DCMAKE_C_FLAGS="$CPPFLAGS $CFLAGS" \
		-DCMAKE_CXX_FLAGS="$CPPFLAGS $CXXFLAGS" \
		-DCMAKE_INSTALL_PREFIX="${S}" \
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=$(usex ipo) \
		-DCMAKE_POSITION_INDEPENDENT_CODE=$(usex pie) \
		-DWITH_SYSTEM_FFMPEG=$(usex ffmpeg) \
		-DWITH_SYSTEM_GLEW=$(usex glex) \
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
