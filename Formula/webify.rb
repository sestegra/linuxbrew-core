class Webify < Formula
  desc "Wrapper for shell commands as web services"
  homepage "https://github.com/beefsack/webify"
  url "https://github.com/beefsack/webify/archive/v1.5.0.tar.gz"
  sha256 "66805a4aef4ed0e9c49e711efc038e2cd4e74aa2dc179ea93b31dc3aa76e6d7b"
  license "MIT"
  head "https://github.com/beefsack/webify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e846193c20d268355845e6d7e8e05dfc6f505749f6560d5ea6b4c8b1e4daf0f"
    sha256 cellar: :any_skip_relocation, big_sur:       "284df018b49ddc0c2a3b8e0800c1997abebee41d198edbd7d725be2f88a8c5e4"
    sha256 cellar: :any_skip_relocation, catalina:      "7b6543358b1c92e8e8cc71584ed52802a039c9327edc839dcc75216fbd23558c"
    sha256 cellar: :any_skip_relocation, mojave:        "8a58b27bcb9d6f9cd611b8f7dfb6192f617854cfcaf8638b388f6dd88ec40f70"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9701f9952fb05880c48c5ca26d14807cf324c2210d4b45d0fb5408243d8d76cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "264daf6af9e950b0e80e4b69ab4d6ce4d4502a16b256b2204283e51c0cbc14ef" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port
    fork do
      exec bin/"webify", "-addr=:#{port}", "cat"
    end
    sleep 1
    assert_equal "Homebrew", shell_output("curl -s -d Homebrew http://localhost:#{port}")
  end
end
