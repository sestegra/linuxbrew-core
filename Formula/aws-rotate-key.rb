class AwsRotateKey < Formula
  desc "Easily rotate your AWS access key"
  homepage "https://github.com/stefansundin/aws-rotate-key"
  url "https://github.com/stefansundin/aws-rotate-key/archive/v1.0.7.tar.gz"
  sha256 "9dadb689583dc4d8869a346c2e7f12201e1fe65d5bf1d64eb09b69f65518bc44"
  license "MIT"
  head "https://github.com/stefansundin/aws-rotate-key.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f386fd25ede2321a6f64f20ccbaa0d3de3079e96b24689f07accc710bd7cfc6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae4352b4f481dbcb3d5538c6140f4fc0c7c6af45e844d2a1740944ef09191226"
    sha256 cellar: :any_skip_relocation, catalina:      "b45abd46858f15815ca5a1cf540e508c4e05051c4d9448133a04ff23f026843b"
    sha256 cellar: :any_skip_relocation, mojave:        "afbf03d4e1323d8cb41ae103ce1bf9de456883d8df92e418f8c69fc54d57126e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394c17427def09e5ad893e535103a806c3715c6fe819498b2aeeb8620ddac52a" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"credentials").write <<~EOF
      [default]
      aws_access_key_id=AKIA123
      aws_secret_access_key=abc
    EOF
    output = shell_output("AWS_SHARED_CREDENTIALS_FILE=#{testpath}/credentials #{bin}/aws-rotate-key -y 2>&1", 1)
    assert_match "InvalidClientTokenId: The security token included in the request is invalid", output
  end
end
