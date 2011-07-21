# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils eutils

DESCRIPTION="A lightweight C++ OpenGL middleware for 2D/3D graphics"
HOMEPAGE="http://www.visualizationlibrary.org/"
SRC_URI="http://www.visualizationlibrary.org/downloads/Visualization_Library_SDK-${PV}.tgz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc data debug examples glut sdl qt4 wxwidgets"

DEPEND="doc? ( app-doc/doxygen )
        glut? ( media-libs/freeglut )
        sdl? ( media-libs/libsdl[opengl] )
        qt4? ( x11-libs/qt-opengl )
	      wxwidgets? ( x11-libs/wxGTK[opengl] )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	mv Visualization_Library_SDK ${P}

	cd ${S}
	epatch "${FILESDIR}"/${P}-cmake.patch
}

src_configure() {
	# benchmarks (BTL) brings up damn load of external deps including fortran
	# compiler
	CMAKE_BUILD_TYPE="Release"
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	fi

	mycmakeargs="-DVL_IO_2D_PNG=ON -DVL_IO_2D_TIFF=ON -DVL_IO_2D_JPEG=ON"

	if use doc; then
		mycmakeargs=" ${mycmakeargs} -DVL_INSTALL_DOCS=ON "
	fi
	if use data; then
		mycmakeargs=" ${mycmakeargs} -DVL_INSTALL_DATA=ON"
	fi
	if use glut; then
		mycmakeargs=" ${mycmakeargs} -DVL_GUI_GLUT_SUPPORT=ON"
		if use examples; then
			mycmakeargs=" ${mycmakeargs} -DVL_GUI_GLUT_EXAMPLES=ON"
		fi
	fi
	if use sdl; then
		mycmakeargs=" ${mycmakeargs} -DVL_GUI_SDL_SUPPORT=ON"
		if use examples; then
			mycmakeargs=" ${mycmakeargs} -DVL_GUI_SDL_EXAMPLES=ON"
		fi
	fi
	if use qt4; then
		mycmakeargs=" ${mycmakeargs} -DVL_GUI_QT4_SUPPORT=ON"
		if use examples; then
			mycmakeargs=" ${mycmakeargs} -DVL_GUI_QT4_EXAMPLES=ON"
		fi
	fi
	if use wxwidgets; then
		mycmakeargs=" ${mycmakeargs} -DVL_GUI_WXWIDGETS_SUPPORT=ON"
		if use examples; then
			mycmakeargs=" ${mycmakeargs} -DVL_GUI_WXWIDGETS_EXAMPLES=ON"
		fi
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
