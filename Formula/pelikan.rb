class Pelikan < Formula
  desc "Production-ready cache services"
  homepage "https://twitter.github.io/pelikan"
  url "https://github.com/twitter/pelikan/archive/0.1.2.tar.gz"
  sha256 "c105fdab8306f10c1dfa660b4e958ff6f381a5099eabcb15013ba42e4635f824"
  license "Apache-2.0"
  head "https://github.com/twitter/pelikan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22f695e695353e9317b34caf92789363464100d5ef63a7883a393767030e9951"
    sha256 cellar: :any_skip_relocation, big_sur:       "98b69e12d5ba1d3e8824e87f3fa5773a3bf7ba63dc2c32c73f07839b2c9d0e81"
    sha256 cellar: :any_skip_relocation, catalina:      "61441ad2aeeb6d14ab8fa6183944c1f4ab0733776e3f810ad17b80faf2f25faf"
    sha256 cellar: :any_skip_relocation, mojave:        "a313660eb003974995537cef07e391d3051218f7c65f3326c270b68f0855a59f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a80ae1b508d4eae75d03fc5ad07477039a50a37419681b2472af4f9dc5f240ea"
    sha256 cellar: :any_skip_relocation, sierra:        "37a675674b7ef33f07099029042f56c054f09b5d22400010d583fbfa41c0ce50"
    sha256 cellar: :any_skip_relocation, el_capitan:    "e314ce6288bf76e271bf69ce844e2e846b16cad68ce635faf1e5130c3c6911d0"
    sha256 cellar: :any_skip_relocation, yosemite:      "ab04b8488e6272d0000c8e67842c4b286eb23459a6de9e9a392f14aa87c9978e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8cd06c6ade8a905139dddaae5a78f71cd4e3c3a143ad1aaf89fde7ca73d630" # linuxbrew-core
  end

  depends_on "cmake" => :build

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pelikan_twemcache", "-c"
  end
end
