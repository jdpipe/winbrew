require 'formula'

class MsysMan < Formula
  homepage ''
  url 'https://github.com/nddrylliog/msys-man/archive/v0.1.0.tar.gz'
  version '0.1.0'
  sha1 '5adcfd2483f4e2032de24d81e7ccf13ac6e1aa72'

  def install
    ENV['PREFIX'] = prefix
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
