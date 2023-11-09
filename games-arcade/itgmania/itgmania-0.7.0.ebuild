EAPI=8

PLOCALES="en en_US"

inherit git-r3 cmake

DESCRITPION="Fork of StepMania 5.1, improved for the post-ITG community"
HOMEPAGE="https://github.com/itgmania/itgmania"
EGIT_REPO_URI="https://github.com/itgmania/itgmania.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="abi_x86_64"

IUSE="
+alsa +crash-handler debug +gles2 +gpl +gtk +mp3 +networking
+xinerama +xrandr minimaid parallel-port profiling
+X +xinerama +sdl pulseaudio +xrandr +ipo +pie +crash-handler
-ffmpeg +glew +jpeg +jsoncpp +mad +ogg +pcre +png +libtomcrypt
+libtommath +zlib -clubfantastic jack +wav
"

BDEPEND="
	dev-util/cmake
	dev-util/ninja
	"

STEPMANIA_CI_COMMON_DEPEND="
	ffmpeg? ( media-video/ffmpeg:=[X,alsa,opengl] )
	glew? ( media-libs/glew )
	jsoncpp? ( dev-libs/jsoncpp )
	mad? ( media-libs/libmad )
	png? ( media-libs/libpng )
	libtomcrypt? ( dev-libs/libtomcrypt )
	libtommath? ( dev-libs/libtommath )
	zlib? ( sys-libs/zlib )
	X? ( x11-libs/libX11 )
"

COMMON_DEPEND="${STEPMANIA_CI_COMMON_DEPEND}
	ogg? ( media-libs/libogg media-libs/libvorbis )
	pulseaudio? ( media-libs/libpulse )
	xrandr? ( x11-libs/libXrandr )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2 )
	xinerama? ( x11-libs/libXinerama )

"

AUR_DEPEND="
	dev-lang/lua
	dev-libs/libusb-compat
	media-libs/harfbuzz
	media-libs/libglvnd[X?]
"

ITGMANIA_CI_CD_DEPEND="
	media-libs/glu
	x11-libs/libXinerama
"

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

DEPEND="${NINJA_DEPEND}
	${COMMON_DEPEND}
	${AUR_DEPEND}
	${ITGMANIA_CI_CD_DEPEND}
	${STEPMANIA_CI_CD_DEPEND}
	dev-libs/glib
	dev-libs/libpcre
	dev-libs/libtommath
	x11-libs/gdk-pixbuf
	x11-libs/libXext
	x11-libs/libXtst
"

CMAKE_MAKE_PROGRAM="make"

src_unpack() {
	git-r3_src_unpack
	default
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	[[ -n "${NINJA_DEPEND}" ]] || \
		ewarn "Unknown value '${NINJA}' for \${NINJA}"

	local mycmakeargs=(
		-DWITH_ALSA=$(usex alsa)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_CRASH_HANDLER=$(usex crash-handler)
		-DWITH_GLES2=$(usex gles2)
		-DWITH_GPL_LIBS=$(usex gpl)
		-DWITH_MP3=$(usex mp3)
		-DWITH_OGG=$(usex ogg)
		-DWITH_WAV=$(usex wav)
		-DWITH_XINERAMA=$(usex xinerama)
		-DWITH_MINIMAID=$(usex minimaid)
		-DWITH_PARALLEL_PORT=$(usex parallel-port)
		-DWITH_PROFILING=$(usex profiling)
		-DWITH_SDL=$(usex sdl)
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=$(usex ipo)
		-DCMAKE_POSITION_INDEPENDENT_CODE=$(usex pie)
		-DWITH_SYSTEM_FFMPEG=$(usex ffmpeg)
		-DWITH_SYSTEM_GLEW=$(usex glew)
		-DWITH_CRASH_HANDLER=$(usex crash-handler)
		-DWITH_SYSTEM_JPEG=$(usex jpeg)
		-DWITH_SYSTEM_JSONCPP=$(usex jsoncpp)
		-DWITH_SYSTEM_MAD=$(usex mad)
		-DWITH_SYSTEM_OGG=$(usex ogg)
		-DWITH_SYSTEM_PCRE=$(usex pcre)
		-DWITH_SYSTEM_PNG=$(usex png)
		-DWITH_SYSTEM_TOMCRYPT=$(usex libtomcrypt)
		-DWITH_SYSTEM_TOMMATH=$(usex libtommath)
		-DWITH_SYSTEM_ZLIB=$(usex zlib)
		-DWITH_NETWORKING=$(usex networking)
		-DWITH_XRANDR=$(usex xrandr)
		-DWITH_JACK=$(usex jack)
		-DWITH_X11=$(usex X)
		-DWITH_CLUB_FANTASTIC=$(usex clubfantastic)
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_OSX_ARCHITECTURES=x86_64
		-DBUILD_64=ON
		-DWITH_FULL_RELEASE=yes
	)
	cmake_src_configure
}


src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	make_wrapper itgmania "/usr/$(get_libdir)/${PN}/${PN}" "/usr/$(get_libdir)/${PN}"
	exeinto "/usr/$(get_libdir)/${PN}"
	newexe "${PN}-release-symbols" "${PN}" || die "dobin failed"
	doexe GtkModule.so || die "doexe GtkModule.so failed"
	insinto "/usr/$(get_libdir)/${PN}"
	! [ -d Announcers ] && mkdir Announcers
	doins -r Announcers BackgroundEffects BackgroundTransitions \
		BGAnimations Characters Courses Data NoteSkins Songs Themes || die "doins failed"
	if ! use bundled-songs; then
		keepdir "/usr/$(get_libdir)/${PN}/Songs"
	fi
	if ! use bundled-courses; then
		keepdir "/usr/$(get_libdir)/${PN}/Courses"
	fi
	dodoc -r Docs/* || die "dodoc failed"
	newicon "Themes/default/Graphics/Common window icon.png" "${PN}.png"
	make_desktop_entry "${PN}" StepMania
}
