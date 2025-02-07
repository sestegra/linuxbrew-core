class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz"
  sha256 "a9eceb1ad88c1f1545cd7bd28e7cbc0b2c14191d40238f531a15b01b1b22cd33"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_ttf[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, x86_64_linux: "92820c9099c3d6e4fbf1c3f1a8b609ef3e476bcb9e993d0b5f070b97479e65fe" # linuxbrew-core
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_ttf", "-o", "test"
    system "./test"
  end
end
