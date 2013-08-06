require 'formula'

class Bzip2 < Formula
  homepage 'http://www.bzip.org/'
  url 'http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz'
  sha1 '3f89f861209ce81a6bab1fd1998c0ef311712002'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def patches
    # chmod the .exe, not the bare files
    DATA
  end
end
__END__
diff --git a/Makefile b/Makefile
index 9754ddf..40e189f 100644
--- a/Makefile
+++ b/Makefile
@@ -79,10 +79,10 @@ install: bzip2 bzip2recover
 	cp -f bzip2 $(PREFIX)/bin/bunzip2
 	cp -f bzip2 $(PREFIX)/bin/bzcat
 	cp -f bzip2recover $(PREFIX)/bin/bzip2recover
-	chmod a+x $(PREFIX)/bin/bzip2
-	chmod a+x $(PREFIX)/bin/bunzip2
-	chmod a+x $(PREFIX)/bin/bzcat
-	chmod a+x $(PREFIX)/bin/bzip2recover
+	chmod a+x $(PREFIX)/bin/bzip2.exe
+	chmod a+x $(PREFIX)/bin/bunzip2.exe
+	chmod a+x $(PREFIX)/bin/bzcat.exe
+	chmod a+x $(PREFIX)/bin/bzip2recover.exe
 	cp -f bzip2.1 $(PREFIX)/man/man1
 	chmod a+r $(PREFIX)/man/man1/bzip2.1
 	cp -f bzlib.h $(PREFIX)/include
