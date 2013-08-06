require 'formula'

class Ncurses < Formula
  homepage 'http://www.gnu.org/software/ncurses/'
  url 'ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz'
  sha1 '3e042e5f2c7223bffdaac9646a533b8c758b65b5'

  def install
    args = %W[
      --enable-term-driver
      --enable-sp-funcs
    ]

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", *args
    system "make", "install"
  end
end
