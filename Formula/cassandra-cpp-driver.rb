class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.16.1.tar.gz"
  sha256 "168d6fe9f3cf61be82cf5817024b92a186d7f944f0d390ed546f521bdabfc32e"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c3127af73fe5c279aa1fce70d690770b00bc6754a74b9163fde9c897122517da"
    sha256 cellar: :any,                 big_sur:       "a27012349a4335a6e68c87d043883b366e81b592ef0b5465281298b1c7d8aba9"
    sha256 cellar: :any,                 catalina:      "19a4f1d92582723258c06b8e9f49783520d05ab4966de3a0ce29089d9e1bac59"
    sha256 cellar: :any,                 mojave:        "9832a774e184a7bb13e060983cbab2ddbe63af9bbc2b36394eb74a855e6fbcde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd653b40e16ed399bbf133f96f627b12bb33d09ad8bf1156b76ab617284799ad" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DLIBUV_ROOT_DIR=#{Formula["libuv"].opt_prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cassandra.h>

      int main(int argc, char* argv[]) {
        CassCluster* cluster = cass_cluster_new();
        CassSession* session = cass_session_new();

        CassFuture* future = cass_session_connect(session, cluster);

        // Because we haven't set any contact points, this connection
        // should fail even if a server is running locally
        CassError error = cass_future_error_code(future);
        if (error != CASS_OK) {
          printf("connection failed");
        }

        cass_future_free(future);

        cass_session_free(session);
        cass_cluster_free(cluster);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcassandra", "-o", "test"
    assert_equal "connection failed", shell_output("./test")
  end
end
