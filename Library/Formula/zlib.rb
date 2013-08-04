require 'formula'

class Zlib < Formula
  homepage ''
  url 'http://zlib.net/zlib-1.2.8.tar.gz'
  sha1 'a4d316c404ff54ca545ea71a27af7dbc29817088'

  def install
    ENV['PREFIX'] = prefix
    ENV['SHARED_MODE'] = '1'
    ENV['INCLUDE_PATH'] = "#{prefix}/include"
    ENV['LIBRARY_PATH'] = "#{prefix}/lib"
    ENV['BINARY_PATH'] = "#{prefix}/bin"

    system "make", "-fwin32/Makefile.gcc"
    system "make", "-fwin32/Makefile.gcc", "test", "testdll"
    system "make", "-fwin32/Makefile.gcc", "install"
  end
end
