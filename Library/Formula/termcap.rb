require 'formula'

class Termcap < Formula
  homepage 'http://www.gnu.org/software/termutils/'
  url 'http://ftp.gnu.org/gnu/termcap/termcap-1.3.1.tar.gz'
  sha1 '42dd1e6beee04f336c884f96314f0c96cc2578be'

  def install
    ENV.O1

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
