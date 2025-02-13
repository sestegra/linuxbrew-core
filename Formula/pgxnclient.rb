class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff78ce343da4b3263d62e0abfdeec116654164c17c7f8b4c331d4d41bedf9f71"
    sha256 cellar: :any_skip_relocation, big_sur:       "c55f89e481e1370e6317e2c88fe8feaf9ea45ba77c1bc0271820ee0342a18f88"
    sha256 cellar: :any_skip_relocation, catalina:      "ea14f4f1f7ff41bca74ed37cd20f19f1075317c9770a2ae020e2af3292bf4448"
    sha256 cellar: :any_skip_relocation, mojave:        "aa91157d1e34e8518a285364fed65ad4a85eb6d7fb3afc8182bcb645b8945af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22495ab0ca0389976987a17c126eae55e2f97c2bc8b9db948fce22115b6aee7a" # linuxbrew-core
  end

  depends_on "python@3.9"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
  end
end
