class Sdl < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick and graphics"
  homepage "https://www.libsdl.org/"
  license "LGPL-2.1-only"
  revision 3

  stable do
    url "https://www.libsdl.org/release/SDL-1.2.15.tar.gz"
    sha256 "d6d316a793e5e348155f0dd93b979798933fb98aa1edebcc108829d6474aad00"
    # Fix for a bug preventing SDL from building at all on OSX 10.9 Mavericks
    # Related ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
    patch do
      url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1320"
      sha256 "ba0bf2dd8b3f7605db761be11ee97a686c8516a809821a4bc79be738473ddbf5"
    end

    # Fix compilation error on 10.6 introduced by the above patch
    patch do
      url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1324"
      sha256 "ee7eccb51cefff15c6bf8313a7cc7a3f347dc8e9fdba7a3c3bd73f958070b3eb"
    end

    # Fix mouse cursor transparency on 10.13, https://bugzilla.libsdl.org/show_bug.cgi?id=4076
    if MacOS.version == :high_sierra
      patch do
        url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=3721"
        sha256 "954875a277d9246bcc444b4e067e75c29b7d3f3d2ace5318a6aab7d7a502f740"
      end
    end

    # Fix display issues on 10.14+, https://bugzilla.libsdl.org/show_bug.cgi?id=4788
    if MacOS.version >= :mojave
      patch do
        url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=4288"
        sha256 "5a89ddce5deaf72348792d33e12b5f66d0dab4f9747718bb5021d3067bdab283"
      end
    end

    # Fix audio initialization issues on Big Sur, upstream patch
    # https://github.com/libsdl-org/SDL-1.2/commit/a2047dc403ffb58b89b717929637352045699743
    if MacOS.version >= :big_sur
      patch do
        url "https://github.com/libsdl-org/SDL-1.2/commit/a2047dc403ffb58b89b717929637352045699743.patch?full_index=1"
        sha256 "7684a923dfd0c13f1a78e09ca0cea2632850e4d41023867b504707946ec495d4"
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3fda7b3047ffff537ba6f2a5711fd03f50fa776546d7788f42a4df325944fcf"
    sha256 cellar: :any, big_sur:       "d97aac056338f24b09ff065d8a80c6f5e9b6e16aed93003764054f6703093ecd"
    sha256 cellar: :any, catalina:      "060c0297dd0af2e289196aa196341ece04f3ab4a3458d173e74f2a3865046a8f"
    sha256 cellar: :any, mojave:        "683450f850acbc501144207d237d28a9c3d0af86533065db7bf7b23ae2d1f6e5"
    sha256 cellar: :any, x86_64_linux:  "4a6198502c14a42ebc32f031119055578a5aec41be4363f21a054773c8d01c6a" # linuxbrew-core
  end

  head do
    url "https://github.com/libsdl-org/SDL-1.2.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  deprecate! date: "2013-08-17", because: :deprecated_upstream

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl.pc.in sdl-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --without-x]
    system "./configure", *args
    system "make", "install"

    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"] if build.stable?
  end

  test do
    system bin/"sdl-config", "--version"
  end
end
