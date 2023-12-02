EAPI=8

inherit cmake

DESCRIPTION="Fork of StepMania 5.1, improved for the post-ITG community"
HOMEPAGE="https://www.itgmania.com/"
SRC_URI="https://github.com/itgmania/itgmania/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk X +crash-handler pulseaudio alsa jack oss +nasm yasm -club-fantastic lto +gles2 +ffmpeg -system-ffmpeg +mp3 +wav"

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
	system-ffmpeg? ( media-video/ffmpeg )
	media-libs/libglvnd
	"
DEPEND="${RDEPEND}"
BDEPEND= "
	dev-util/cmake
	"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X ON OFF)
		-DWITH_XRANDR=$(usex X ON OFF)
		-DWITH_LIBXTST=$(usex X ON OFF)
		-DWITH_CRASH_HANDLER=$(usex crash-handler ON OFF)
		-DWITH_GTK3=$(usex gtk ON OFF)
		-DWITH_PULSEAUDIO=$(usex pulseaudio ON OFF)
		-DWITH_ALSA=$(usex alsa ON OFF)
		-DWITH_JACK=$(usex jack ON OFF)
		-DWITH_OSS=$(usex oss ON OFF)
		-DWITH_NASM=$(usex nasm ON OFF)
		-DWITH_YASM=$(usex yasm ON OFF)
		-DWITH_CLUB_FANTASTIC=$(usex club-fantastic ON OFF)
		-DCMAKE_BUILD_TYPE=Release
		-DWITH_FULL_RELEASE=On
		-DWITH_LTO=$(usex lto ON OFF)
		-DWITH_FFMPEG=$(usex ffmpeg ON OFF)
		-DWITH_SYSTEM_FFMPEG=$(usex system-ffmpeg ON OFF)
		-DWITH_MP3=$(usex mp3 ON OFF)
		-DWITH_WAV=$(usex wav ON OFF)
	)
	cmake_src_configure
}
