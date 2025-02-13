class Airspy < Formula
  desc "Driver and tools for a software-defined radio"
  homepage "https://airspy.com/"
  url "https://github.com/airspy/airspyone_host/archive/v1.0.10.tar.gz"
  sha256 "fcca23911c9a9da71cebeffeba708c59d1d6401eec6eb2dd73cae35b8ea3c613"
  head "https://github.com/airspy/airspyone_host.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "3cebc54737172b116e3cdabc7770777954b6c1840940588cd29f431c4db526c7"
    sha256                               big_sur:       "acada5e4e39e99dfad89cbcd1d0440cc3b4814936160b37220059cf602b94b4d"
    sha256                               catalina:      "5e8d910759443d83f3975b41e2805b4bfeb605d55271f0e37e8ca7de470415f0"
    sha256                               mojave:        "28e8a9afd6a78a3c091e70d0326431a68738ec26e08448d88d62974374a08a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3287a4bae876ea0fd56c2275a6dc274196d7a2edd334a5a5e7cdf0d942afa09" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    libusb = Formula["libusb"]
    args << "-DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-1.0"
    args << "-DLIBUSB_LIBRARIES=#{libusb.opt_lib}/#{shared_library("libusb-1.0")}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/airspy_lib_version").chomp
  end
end
