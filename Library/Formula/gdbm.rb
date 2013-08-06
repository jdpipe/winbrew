require 'formula'

class Gdbm < Formula
  homepage 'http://www.gnu.org/software/gdbm/'
  url 'http://ftpmirror.gnu.org/gdbm/gdbm-1.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gdbm/gdbm-1.10.tar.gz'
  sha1 '441201e9145f590ba613f8a1e952455d620e0860'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # configure tests fail otherwise on GCC 4.7.x
    ENV.O1

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end

  def patches
    # Various patches for MinGW compatibility:
    # emulate fsync, don't use SIGPIPE, don't use ioctl,
    # use winsock instead of inet.h
    [
      'https://gist.github.com/nddrylliog/6166764/raw/d480df7957269862a56fde8f54377b2b8e2291e8/fsync-emulation.patch',
      'https://gist.github.com/nddrylliog/6166764/raw/8090b2ea762ebc5429ecbf961aeea01dbd50500f/testgdbm.patch',
      'https://gist.github.com/nddrylliog/6166764/raw/c66cc60160568d179d8ed1efc279e621c8619774/winsock-configure.patch',
      'https://gist.github.com/nddrylliog/6166764/raw/32e0cad4c5a35e7a7be97b0fb26cd7de4f1a2433/winsock.patch'
    ]
  end
end
