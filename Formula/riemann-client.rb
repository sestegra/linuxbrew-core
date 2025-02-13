class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.4.tar.gz"
  sha256 "334874f0b9a507a8abbc7138df719cba4f28f12c02c39d5e55090b8edb86f9d2"
  license "LGPL-3.0"
  revision 1
  head "https://github.com/algernon/riemann-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0d4d437c6d0f17a436d78d7d0a31e2031e049a3a4d822a72bbb587da6f65d25b"
    sha256 cellar: :any, big_sur:       "d0fc546788b990e07850b71d51326cfa79fbdb753415acccf21d85239931831b"
    sha256 cellar: :any, catalina:      "3227f7774fb1ff0e7daeb4b8c75c0e976a928593b85a8ef2726542ef3bab634b"
    sha256 cellar: :any, mojave:        "1a11eb37bbb1021c3aee0e2e5173dba58fb48172418cf632e76811f08483a39d"
    sha256 cellar: :any, high_sierra:   "245fe4d845c711bc9d1b99f0697d1cb98811633a608c62f415a4e2c0f05ebd1a"
    sha256 cellar: :any, x86_64_linux:  "40f04bf7269b9de06c801f6ed576939c0d4364f8ba69b5a0fb385033596c64be" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end
