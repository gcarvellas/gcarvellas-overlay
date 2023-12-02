EAPI=8

inherit cmake

# Cannot use ninja generator when building the bundled ffmpeg library
CMAKE_MAKEFILE_GENERATOR="emake"

DESCRIPTION="Fork of StepMania 5.1, improved for the post-ITG community"
HOMEPAGE="https://www.itgmania.com/"
SRC_URI="https://github.com/itgmania/itgmania/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk X +crash-handler pulseaudio alsa jack oss +nasm yasm -club-fantastic lto +gles2 +ffmpeg"

RDEPEND="
	gtk? ( >=x11-libs/gtk+-3 )
	X? ( x11-libs/libX11 x11-libs/libXrandr x11-libs/libXtst )
	pulseaudio? ( media-libs/libpulse )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-libs/jack2 )
	oss? ( media-libs/alsa-oss )
	nasm? ( dev-lang/nasm )
	yasm? ( dev-lang/yasm )
	gles2? ( media-libs/glew )
	ffmpeg? ( media-video/ffmpeg )
	media-libs/libglvnd
	"
DEPEND="${RDEPEND}"

#BDEPEND= "
#	dev-util/cmake
#	"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
		-DWITH_XRANDR=$(usex X)
		-DWITH_LIBXTST=$(usex X)
		-DWITH_CRASH_HANDLER=$(usex crash-handler)
		-DWITH_GTK3=$(usex gtk)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_ALSA=$(usex alsa)
		-DWITH_JACK=$(usex jack)
		-DWITH_OSS=$(usex oss)
		-DWITH_NASM=$(usex nasm)
		-DWITH_YASM=$(usex yasm)
		-DWITH_CLUB_FANTASTIC=$(usex club-fantastic)
		-DCMAKE_BUILD_TYPE=Release
		-DWITH_FULL_RELEASE=On
		-DWITH_LTO=$(usex lto)
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_FFMPEG_JOBS=2
	)
	cmake_src_configure
}
