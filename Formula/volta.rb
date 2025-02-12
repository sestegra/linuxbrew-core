class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.5",
      revision: "b8ae859c5b25fb076a93f0d8a0cccc93e7ad8018"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dbcd14a0a63d19d4ac28d20b20d849a14369374cb36f68cc4ae994208324ff6"
    sha256 cellar: :any_skip_relocation, big_sur:       "f43ad29f446309d9c9fca3031b58dec129134a24dbabdca703e8bf1de6b035cb"
    sha256 cellar: :any_skip_relocation, catalina:      "8587132e7bc5b76dcac2f47372494a0bc1ceccf19e4eeecc6e29f12f9f8bc824"
    sha256 cellar: :any_skip_relocation, mojave:        "ade25632752bf387752f88e015694a0b1e353df3922357b51f846b4bfde9ccf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867738e296d4cacd7cb7b144ff9e0a550fcff5664006474a4dfd27493bc7e199" # linuxbrew-core
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/volta", "completions", "bash")
    (bash_completion/"volta").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/volta", "completions", "zsh")
    (zsh_completion/"_volta").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/volta", "completions", "fish")
    (fish_completion/"volta.fish").write fish_output
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
