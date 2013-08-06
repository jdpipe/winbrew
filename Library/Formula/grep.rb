require 'formula'

class Grep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'ftp://ftp.gnu.org/gnu/grep/grep-2.9.tar.xz'
  sha1 '0395eddfbf23e8ef1475677fce7c19a631abea41'

  depends_on 'xz' => :build

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
