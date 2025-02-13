require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.6.tgz"
  sha256 "c0e9318699acc678abb105bbc18f5deff3e88604ce5370dd61c5c7d8103a1b6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18182eda193a884a21f9a61001d3e9782801d3305222e7710693051fc61dd077"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a6fe3e4496eb3ebfd48eb6f722e411eb5085434f6df75d16914aee7ef8fe9ef"
    sha256 cellar: :any_skip_relocation, catalina:      "8a6fe3e4496eb3ebfd48eb6f722e411eb5085434f6df75d16914aee7ef8fe9ef"
    sha256 cellar: :any_skip_relocation, mojave:        "8a6fe3e4496eb3ebfd48eb6f722e411eb5085434f6df75d16914aee7ef8fe9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5520cee6e2ba8b590d54c5d80aa6604916f14a2ede0162b633554af87767f699" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end
