require 'formula'

class PkgConfig < Formula
  # Actually using pkg-config-lite, which doesn't require glib
  # 0.28.1-1 doesn't build (fails 4/25 tests on MinGW), stay with 0.27.x for now
  homepage 'http://sourceforge.net/projects/pkgconfiglite/'
  url 'http://downloads.sourceforge.net/project/pkgconfiglite/0.27.1-1/pkg-config-lite-0.27.1-1.tar.gz'
  sha256 '0fcac60ae7ad8e705c30fb5f8f83e75b09f54e1c80a2f6814c346bf5f1dba9a0'
  version '0.27.1-1'

  def install
    paths = %W[
        #{HOMEBREW_PREFIX}/lib/pkgconfig
        #{HOMEBREW_PREFIX}/share/pkgconfig
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
      ].uniq

    args = %W[
        --disable-debug
        --prefix=#{prefix}
        --disable-host-tool
        --with-pc-path=#{paths*':'}
      ]
    args << "CC=#{ENV.cc} #{ENV.cflags}" unless MacOS::CLT.installed?

    system "./configure", *args

    system "make"
    system "make check"
    system "make install"
  end
end
