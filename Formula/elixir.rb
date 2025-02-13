class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.12.3.tar.gz"
  sha256 "c5affa97defafa1fd89c81656464d61da8f76ccfec2ea80c8a528decd5cb04ad"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a853f176067849a6f5d5441a2ceda381d6b758065eddec2ba9f472a6cd6870e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "cefbc6925f57d73b244c45c6cfb4c527b83b9c3f24d43035275d8690b50b16dc"
    sha256 cellar: :any_skip_relocation, catalina:      "54af07dcdf6f41708570cb45e0eb5ef7a1658d90028ba8453f3e8cc5e1df8fcc"
    sha256 cellar: :any_skip_relocation, mojave:        "d60b62c1e2cb43410169e748dc603ac34473064ebce70dbf3a397b227a1dc2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55365953653aa46dc22aa74d477292d9976caa4d4cea2321aa01eefa0f58e32" # linuxbrew-core
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
