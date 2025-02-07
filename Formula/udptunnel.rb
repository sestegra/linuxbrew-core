class Udptunnel < Formula
  desc "Tunnel UDP packets over a TCP connection"
  # The original webpage (and download) is still available at the original
  # site, but currently www.cs.columbia.edu returns a 404 error if you
  # try to fetch them over https instead of http
  homepage "https://web.archive.org/web/20161224191851/www.cs.columbia.edu/~lennox/udptunnel/"
  url "https://pkg.freebsd.org/ports-distfiles/udptunnel-1.1.tar.gz"
  mirror "https://sources.voidlinux.org/udptunnel-1.1/udptunnel-1.1.tar.gz"
  sha256 "45c0e12045735bc55734076ebbdc7622c746d1fe4e6f7267fa122e2421754670"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cd9168b47649ced46a6bc58b90d8bb9cf6031fe3f839101743ca5b6dda3efbf"
    sha256 cellar: :any_skip_relocation, big_sur:       "bfb564a4529a508338776cc02b0b4fcd63ceead924db45ef73f4c41c79f96908"
    sha256 cellar: :any_skip_relocation, catalina:      "de4e78f6f0ff861478dae683d1a6c09ae38e9a9e7ec8780a90a9b849df422089"
    sha256 cellar: :any_skip_relocation, mojave:        "46dca7ebedab0825acffeafa11b6090676993a5b7b4a53591db51cc7b856e048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68bfacffcb5588dbb7baab47b02bfabe04f6327a5317975e25bbc9a0020a692e" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Work around build issues with Xcode 12:
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "udptunnel.html"
  end

  test do
    system "#{bin}/udptunnel -h; true"
  end
end
