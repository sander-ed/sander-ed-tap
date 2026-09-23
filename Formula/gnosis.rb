class Gnosis < Formula
  desc "Git-backed OKF package manager"
  homepage "https://github.com/sander-ed/gnosis"
  url "https://github.com/sander-ed/gnosis.git",
      tag:      "v0.2.0",
      revision: "438f6c2f36610514266ca72506cb1d83e26a715d"

  depends_on "rust" => :build
  depends_on "git"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gnosis #{version}", shell_output("#{bin}/gnosis --version")
    assert_match "Usage: gnosis", shell_output("#{bin}/gnosis --help")
  end
end
