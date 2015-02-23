pkgname=podterm-git
pkgver=$(date +%Y%m%d_%H%M)
pkgrel=1
pkgdesc="podcast cliant cui." 
arch=('i686' 'x86_64')
url="https://github.com/naniwaradio/podTerm"
license=('MIT')
depends=('bash' 'mpv' 'ruby')
optdepends=('zeromq')
makedepends=('git')
source=('podTerm::git+https://github.com/naniwaradio/podTerm.git')
md5sums=('SKIP')

pkgver() {
	cd "$srcdir/podTerm"
	# Use the tag of the last commit
	git describe --long | sed -E 's/([^-]*-g)/r\1/;s/-/./g'
}


package() {
	cd "$srcdir/podTerm"
	install -Dm755 "pot" "${pkgdir}/usr/bin/pot"
	install  -Dm755 "podterm/podterm.rb" "${pkgdir}/usr/bin/podterm/podterm.rb"
	install  -Dm755 "podterm/help" "${pkgdir}/usr/bin/podterm/help"
}
