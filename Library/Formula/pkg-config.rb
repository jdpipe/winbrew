require 'formula'

class PkgConfig < Formula
  homepage 'http://sourceforge.net/projects/pkgconfiglite/'
  url 'http://downloads.sourceforge.net/project/pkgconfiglite/0.28-1/pkg-config-lite-0.28-1.tar.gz'
  sha256 '21b76ec4e115ee30f9b3077a2506e48e8b837332ed4d30c9776502e69c6a29e5'

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
