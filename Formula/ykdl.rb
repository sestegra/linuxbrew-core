class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/bb/15/ab7977a060f55a90f5cffb86dbc1327f3eaffbfdf88f0844a04add1199a8/ykdl-1.7.2.tar.gz"
  sha256 "abef7b5f3fbdbfc240fe3a6222b3feecc8d1f71969ad09d5f82779088272b9a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23495a922f681f2d85daea61ddd4938d2d4c820a81454f997f010319f7fad3e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea08358d1a69a6ed3fe9e2d04f0d001b8974536649340d1f900e750d4e593ff5"
    sha256 cellar: :any_skip_relocation, catalina:      "4f60d7126c66d623597faee5de0ac1ae3dac74d5dbe974eb1e04ef12d50684c7"
    sha256 cellar: :any_skip_relocation, mojave:        "83a523904030379eb569bd011cc1d765c1f9cdbbcbb6696050329f850cacde63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e4dcc21492708f0d8b008377174530e86b0558df67cfbd08a48eaebe8f8faa" # linuxbrew-core
  end

  depends_on "python@3.9"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/45/66/a943f702763c879e2754b46089a136ee1e58f0f720c58fa640c00281d3fd/iso8601-0.1.16.tar.gz"
    sha256 "36532f77cc800594e8f16641edae7f1baf7932f05d8e508545b95fc53c6dc85b"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/f4/1f/6370b6c5ba1975f5299bdda0e953e381880accbad1d2daa8fb0da3548051/m3u8-0.9.0.tar.gz"
    sha256 "3ee058855c430dc364db6b8026269d2b4c1894b198bcc5c824039c551c05f497"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/88/7f/740b99ffb8173ba9d20eb890cc05187677df90219649645aca7e44eb8ff4/pycryptodome-3.10.1.tar.gz"
    sha256 "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAzNDM5NTQ5Mg==.html"
  end
end
