class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.16",
      revision: "b0931695a2f2a30c495e2c8ad77c7721bf34bac4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8175c0c0c8d41391447683ee65fe87e89ca8cb91703b602a4fdeac609b2cfe3f"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ff0cc2c4ea5e3f931161ca925c2cb4198977a0a0f234c67a92e0eab084768bc"
    sha256 cellar: :any_skip_relocation, catalina:      "c29bfb3d2df0d397d82aa6cf84897a0e4e3e32268240132fd801b655cbf3298a"
    sha256 cellar: :any_skip_relocation, mojave:        "cfda2f95744685e5b323271251d3a3d36af9369eaa7c9d7e22976efcb1cd7f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58f04f22bd6960abc5fffaf5ca929d2b626e5eda42e6d5dd3538e6c644ad0879" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
