class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftp.gnu.org/gnu/gtypist/gtypist-2.9.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/gtypist/gtypist-2.9.5.tar.xz"
  sha256 "c13af40b12479f8219ffa6c66020618c0ce305ad305590fde02d2c20eb9cf977"
  revision 2

  bottle do
    sha256 arm64_big_sur: "b241409e921daccc7d82bfd1641ba1b6fd43966d19458fc580d4245641306fe2"
    sha256 big_sur:       "74506e983cf7d74abcd8cfa4007d8429cdae7283a1b3cd3a3f0272d4380df024"
    sha256 catalina:      "2a824f3fad3871cbf43f15009c23563aa03872597f22e823f9e2551d35fe1e26"
    sha256 mojave:        "9f0fcdd42b9a041408b132882778db2eb479749a7169b82f2caf1f4fd486b599"
    sha256 high_sierra:   "72503afd4efafe7a8485ea22332819937008263976a6f5f5b42818565d59edbf"
    sha256 sierra:        "d32708d6e8a640101ac618ceac23be6b9d1a6a4caa127c5fd12a44b4e57c09e9"
    sha256 x86_64_linux:  "96f7d1fe80ea3c8e5a6687b0a2e7ce519d97b933cd42219cb9ef6837150ce8c5" # linuxbrew-core
  end

  depends_on "gettext"

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/42c4b96/gnu-typist/2.9.5.patch"
    sha256 "a408ecb8be3ffdc184fe1fa94c8c2a452f72b181ce9be4f72557c992508474db"
  end

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    session = fork do
      exec bin/"gtypist", "-t", "-q", "-l", "DEMO_0", share/"gtypist/demo.typ"
    end
    sleep 2
    Process.kill("TERM", session)
  end
end
