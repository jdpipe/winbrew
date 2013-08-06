require 'formula'

class Dlfcn < Formula
  homepage 'https://code.google.com/p/dlfcn-win32/'
  url 'https://dlfcn-win32.googlecode.com/files/dlfcn-win32-r19.tar.bz2'
  version 'r19'
  sha1 'a0033e37a547c52059d0bf8664a96ecdeeb66419'

  def install
    args = %W[
      --prefix=#{prefix}
      --incdir=#{prefix}/include
      --libdir=#{prefix}/lib
      --enable-static
      --enable-shared
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def patches
    # configure returns 1 by default... how silly
    DATA
  end
end

__END__
diff --git a/configure b/configure
index 3ae2f88..92f93b9 100644
--- a/configure
+++ b/configure
@@ -190,3 +190,4 @@ enabled shared && {
     echo "msvc:   $msvc";
     echo "strip:  $stripping";
 }
+exit 0
