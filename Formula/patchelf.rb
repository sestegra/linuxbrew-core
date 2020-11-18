class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/archive/0.11.tar.gz"
  sha256 "e9dc4dbed842e475176ef60531c2805ed37a71c34cc6dc5d1b9ad68d889aeb6b"
  license "GPL-3.0-or-later"
  head "https://github.com/NixOS/patchelf.git"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bb0057c1d2da2340687832a9a286a7b9be8a024184d1ca6c218c3a6a3910c714" => :big_sur
    sha256 "bca91d5be894ea5ebc1c7b0af93027e7669c460b7f792455470e78e73fc16d52" => :catalina
    sha256 "d4d4b739c36108e8f794b19a76a44efeed42baeeb4f5dcd61002c7ba29105dfd" => :mojave
    sha256 "d7c841a08ca1f9e4cc24fa6378e14f82f46dac6124d860777fb53161ac82a426" => :high_sierra
    sha256 "7396e6cf5dbe62fae0e7fcba57f88586359561824df9cfe1127b4d88dd6f2a5a" => :x86_64_linux
  end

  resource "helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    on_linux do
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./configure", "--prefix=#{prefix}",
      "CXXFLAGS=-static-libgcc -static-libstdc++",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
