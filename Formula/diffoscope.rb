class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/c2/85/4f8e8fd02e64822c114c5705e1787f09299c8b837236ff6d1f5c0b549512/diffoscope-183.tar.gz"
  sha256 "d2060ad1416fd5abc4a60dcd59bb245f600cf10e89a28257255a0ec7b1687f4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb88c76f4b9fff8f8bb3afb2f5596c4395fd036ae87eb1beb68abc0d7024a3d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c57dbb13437e005686b2c2308d1aca8cf946ff519c08665614cfbf93083342f"
    sha256 cellar: :any_skip_relocation, catalina:      "5fa8f45f2cea7ae85c6acc7e646a4a1bc16b940e6ba858594e67b8151bfc4d17"
    sha256 cellar: :any_skip_relocation, mojave:        "c341a34cbffa04bd06b26b9f22f47d1d048693cc73809aabbbee0b72807a43fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1115f9da341e06cbb0cdb8c33a875fea2f31c909fd90e40cc29818ad507bd7a7" # linuxbrew-core
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.9"

  # Use resources from diffoscope[cmdline]
  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/53/d5/bee2190570a2b4c372a022f16ebfc2313ff717a023f277f5d6f9ebf281a2/libarchive-c-3.1.tar.gz"
    sha256 "618a7ecfbfb58ca15e11e3138d4a636498da3b6bc212811af158298530fbb87e"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/3a/70/76b185393fecf78f81c12f9dc7b1df814df785f6acb545fc92b016e75a7e/python-magic-0.4.24.tar.gz"
    sha256 "de800df9fb50f8ec5974761054a708af6e4246b03b4bdaee993f948947b0ebcf"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
