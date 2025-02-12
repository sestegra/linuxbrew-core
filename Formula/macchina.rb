class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.1.3.tar.gz"
  sha256 "57dddd11445fcc6f696e4fc5bc0ba102caab033d2c4614c1cf10ae6a5fa82988"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "591e899b201ecff29024a6a7b36eb6e358d7b0269b5072b55794744bbc5ec0b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "da4b5c43e10971d0e93d12700a7396b90c1e7c32378d00dde8a7dbe91396a91b"
    sha256 cellar: :any_skip_relocation, catalina:      "55df09d90e450602340d08887667ed0941ae621652c2bd531bcbc751df1569af"
    sha256 cellar: :any_skip_relocation, mojave:        "cbacbfde75d9ce6c38757ba3f8ecdfc9c4344e3d9527c603f5c794fb8fdeef91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2610913dbbc2d5e3a40ae453d480747628d280707c11478ff7b59daa393b89fe" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
