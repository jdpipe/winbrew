require 'formula'

class Groff < Formula
  homepage 'http://www.gnu.org/software/groff/'
  url 'ftp://ftp.gnu.org/gnu/groff/groff-1.22.2.tar.gz'
  sha1 '37223941e25bb504bf54631daaabb01b147dc1d3'

  def install
    ENV.j1

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def patches
    # _GL_INLINE causes problems on MINGW, just undefine it
    DATA
  end
end

__END__
diff --git a/src/libs/gnulib/lib/wctype.in.h b/src/libs/gnulib/lib/wctype.in.h
index 0cd02d5..ea6ee91 100644
--- a/src/libs/gnulib/lib/wctype.in.h
+++ b/src/libs/gnulib/lib/wctype.in.h
@@ -54,6 +54,10 @@
 #ifndef _@GUARD_PREFIX@_WCTYPE_H
 #define _@GUARD_PREFIX@_WCTYPE_H

+#define _GL_INLINE_HEADER_BEGIN
+#define _GL_INLINE
+#define _GL_INLINE_HEADER_END
+
 _GL_INLINE_HEADER_BEGIN
 #ifndef _GL_WCTYPE_INLINE
 # define _GL_WCTYPE_INLINE _GL_INLINE
