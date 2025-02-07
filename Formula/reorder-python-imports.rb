class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/f8/8c/447338a4a8098f28bed79b264a43fbfae4d5d70ec2cc034fc4bc4cfaa827/reorder_python_imports-2.6.0.tar.gz"
  sha256 "f4dc03142bdb57625e64299aea80e9055ce0f8b719f8f19c217a487c9fa9379e"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22f68d1b365aa298c41c8ac4fd8558f734ccdc527a60577f5f40de1e4a8787c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a46bee2a9c8bd602dc21234343a449cdd9a8fb165706e07fea4c155e6a915ba"
    sha256 cellar: :any_skip_relocation, catalina:      "8a46bee2a9c8bd602dc21234343a449cdd9a8fb165706e07fea4c155e6a915ba"
    sha256 cellar: :any_skip_relocation, mojave:        "8a46bee2a9c8bd602dc21234343a449cdd9a8fb165706e07fea4c155e6a915ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3589386939e21d865702c30a745d7f7ff7da8d0656992392e1b6fc3478b10e" # linuxbrew-core
  end

  depends_on "python@3.9"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/a9/e9/cabb3bd114aa24877084f2bb6ecad8bd77f87724d239d360efd08f6fe9db/aspy.refactor_imports-2.2.0.tar.gz"
    sha256 "78ca24122963fd258ebfc4a8dc708d23a18040ee39dca8767675821e84e9ea0a"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
