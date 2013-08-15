require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.32.0.tar.gz'
  mirror 'ftp://ftp.sunet.se/pub/www/utilities/curl/curl-7.32.0.tar.gz'
  sha256 'c979fe2200fdef4219c75087b08b34aa580606a3bf7fc512b2e6b1f79e6a4e7c'

  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-sspi', 'Build with SSPI support'

  depends_on 'pkg-config' => :build

  # There is on built-in OpenSSL on Windows
  depends_on 'openssl'

  # There is on built-in zlib on Windows
  depends_on 'zlib'

  depends_on 'libssh2' if build.with? 'ssh'

  # -Os causes the build to fail, sizeof(long) is undefined
  # superenv doesn't yet support changing the optimization level
  env :std

  def install
    # Disable optimization the hard way
    # With -Os (homebrew default), the sizeof(long) test fails
    # With -O2 (automake default), the sizeof(size_t) test fails
    ENV['CFLAGS'] = '-g -O0'
    ENV['CXXFLAGS'] = '-g -O0'

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-zlib=#{HOMEBREW_PREFIX}
      --with-ssl=#{HOMEBREW_PREFIX}
    ]

    # Shared works with GCC 4.6 but not from GCC 4.7
    # link: http://curl.haxx.se/mail/lib-2013-05/0129.html
    args << '--disable-shared'

    args << '--with-libssh2=#{HOMEBREW_PREFIX}' if build.with? 'ssh'

    system './configure', *args
    system 'make', 'install'
  end
end
