class OpenexrAT2 < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with ilmbase.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.7.tar.gz"
  sha256 "36ecb2290cba6fc92b2ec9357f8dc0e364b4f9a90d727bf9a57c84760695272d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "77d6fcb5f018066f870b1d8a94afe04a55b84e2e3250c4b399d3cdd370692515"
    sha256 cellar: :any,                 big_sur:       "428f7841d12c75fdcf614c636aaf078a079ae16fce6f40510c5c0b3494814e06"
    sha256 cellar: :any,                 catalina:      "514fa634d8cb6fe9d677526ccfa29001765bb1fe7bdd96e03f59dad14bea2c57"
    sha256 cellar: :any,                 mojave:        "4c4fb29b1ba3789441448da68276d373838cff0e72424ac7ea4cb4dbcaed88a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18bf077029c9987a71340e02a71916d80bf8afdb9738f16fb861f4171ca7af0d" # linuxbrew-core
  end

  keg_only :versioned_formula

  deprecate! date: "2021-04-01", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
