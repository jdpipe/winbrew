require 'formula'

class Sdl2Mixer < Formula
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  url 'http://www.libsdl.org/tmp/SDL_mixer/release/SDL2_mixer-2.0.0.zip'
  version '2.0.0'
  sha1 '6c4ef09c755c93837f02345e402f93f5bf0baf07'
  head 'http://hg.libsdl.org/SDL_mixer', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'sdl2'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  depends_on 'libvorbis' => :optional

  def install
    inreplace 'SDL2_mixer.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
