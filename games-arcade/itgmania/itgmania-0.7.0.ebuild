EAPI=8

inherit cmake git-r3

# Cannot use ninja generator when building the bundled ffmpeg library
CMAKE_MAKEFILE_GENERATOR="emake"

DESCRIPTION="Fork of StepMania 5.1, improved for the post-ITG community"
HOMEPAGE="https://www.itgmania.com/"

EGIT_REPO_URI="https://github.com/itgmania/itgmania.git"
EGIT_SUBMODULES=(
	'*'
)
EGIT_COMMIT="28b7659a0999fea52b6fc475673a52157d903454" # v0.7.0 release

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk X +crash-handler pulseaudio alsa jack oss +nasm yasm -club-fantastic lto +gles2 udev"

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
	udev? ( virtual/libudev )

	media-libs/libglvnd
	dev-libs/libusb
	media-libs/libmad
	media-libs/glu
	media-libs/mesa
	"
DEPEND="${RDEPEND}"

#BDEPEND= "
#	dev-util/cmake
#	"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X On Off)
		-DWITH_XRANDR=$(usex X On Off)
		-DWITH_LIBXTST=$(usex X On Off)
		-DWITH_CRASH_HANDLER=$(usex crash-handler On Off)
		-DWITH_GTK3=$(usex gtk On Off)
		-DWITH_PULSEAUDIO=$(usex pulseaudio On Off)
		-DWITH_ALSA=$(usex alsa On Off)
		-DWITH_JACK=$(usex jack On OFf)
		-DWITH_OSS=$(usex oss On Off)
		-DWITH_NASM=$(usex nasm On Off)
		-DWITH_YASM=$(usex yasm On Off)
		-DWITH_CLUB_FANTASTIC=$(usex club-fantastic On Off)
		-DCMAKE_BUILD_TYPE=Release
		-DWITH_FULL_RELEASE=On
		-DWITH_LTO=$(usex lto On Off)
		-DWITH_FFMPEG=$(usex ffmpeg On Off)
	)
	cmake_src_configure
}
