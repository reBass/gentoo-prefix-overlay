# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="git@github.com:thestk/rtaudio https://github.com/thestk/rtaudio.git"
else
	SRC_URI="https://github.com/thestk/rtaudio/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~amd64-linux ~amd64-macosx"
fi

DESCRIPTION="a common API for realtime audio input/output across many platforms"
HOMEPAGE="http://cmus.github.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa coreaudio jack oss pulseaudio debug doc"

REQUIRED_USE="|| ( alsa jack oss pulseaudio )"

DEPEND="alsa? ( media-libs/alsa-lib )
	doc? ( app-doc/doxygen )
	jack? ( media-sound/jack-audio-connection-kit )
	oss? ( media-sound/oss )
	pulseaudio? ( media-sound/pulseaudio )"
RDEPEND=$DEPEND
HDEPEND="virtual/pkgconfig"

# TODO: configure script doesn't

DOCS="readme"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
                eautoreconf
        fi
	epatch_user
}

src_configure() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false
	# use alsa || export ac_cv_prog_HAVE_ALSA=true

        ECONF_SOURCE="${S}" econf \
                $(use alsa && use_with alsa) \
                $(use coreaudio && echo --with-core) \
                $(use_enable debug) \
                $(use oss && use_with oss) \
                $(use pulseaudio && echo --with-pulse) \
		${myconf}


	./configure prefix="${EPREFIX}"/usr ${myconf}
}

