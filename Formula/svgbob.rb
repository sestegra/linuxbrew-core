class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.1.tar.gz"
  sha256 "0207ccfd7b6432705f56d87da40536d8c5dd86fa8f10577de4522a16c4b6b992"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9c3733b17fd814e888c9cac06df9760cd76f9cb45e3cedc75d42385e987254b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f9676ab8effa5a091ea9fdce5e9afc438d0c35b9174580cfd1e090a765909a7"
    sha256 cellar: :any_skip_relocation, catalina:      "e7a40e48c48082fdc20009ca1ab4a916929053a450021fecbbcd1cca00eaf38d"
    sha256 cellar: :any_skip_relocation, mojave:        "cfe41298ae2497a7a5014388229d3ca9fe40888458ae3a191410a44eb768fcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31f6529df1df4d9950d52f5550a847e225ba4e9e5847911dfe8faede81c2fdd7" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "svgbob_cli")
  end

  test do
    (testpath/"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system bin/"svgbob", "ascii.txt", "-o", "out.svg"
    contents = (testpath/"out.svg").read
    assert_match %r{<text.*?>Hello</text>}, contents
    assert_match %r{<text.*?>Homebrew</text>}, contents
  end
end
