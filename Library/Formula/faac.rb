require 'formula'

class Faac < Formula
  homepage 'http://www.audiocoding.com/faac.html'
  url 'http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.gz'
  sha1 'd00b023a3642f81bb1fb13d962a65079121396ee'

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    # some mingw-specific stuff
    DATA
  end
end

__END__
diff --git a/common/mp4v2/mpeg4ip.h b/common/mp4v2/mpeg4ip.h
index 6ee8c5c..82caacc 100644
--- a/common/mp4v2/mpeg4ip.h
+++ b/common/mp4v2/mpeg4ip.h
@@ -61,6 +61,7 @@
 #ifdef _WIN32
 #include "mpeg4ip_win32.h"
 #include "mpeg4ip_version.h"
+#include <ctype.h>
 #else /* UNIX */
 /*****************************************************************************
  *   UNIX LIKE DEFINES BELOW THIS POINT
diff --git a/common/mp4v2/mpeg4ip_win32.h b/common/mp4v2/mpeg4ip_win32.h
index 8664408..d1b46a1 100644
--- a/common/mp4v2/mpeg4ip_win32.h
+++ b/common/mp4v2/mpeg4ip_win32.h
@@ -62,6 +62,7 @@ typedef unsigned short in_port_t;
 typedef int socklen_t;
 typedef int ssize_t;
 typedef unsigned int uint;
+#ifndef __MINGW32__
 static inline int snprintf(char *buffer, size_t count,
 			  const char *format, ...) {
   va_list ap;
@@ -75,11 +76,15 @@ static inline int snprintf(char *buffer, size_t count,
   }
   return ret;
 }
+#endif
+
+#ifndef __MINGW32__
 #define strncasecmp _strnicmp
 #define strcasecmp _stricmp
 #define localtime_r(a,b) localtime_s(b,a)
 #define printf printf_s
 #define fprintf fprintf_s
+#endif
 
 #include <io.h>
 #include <fcntl.h>
