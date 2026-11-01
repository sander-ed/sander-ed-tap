class Gnosis < Formula
  desc "Git-backed OKF package manager"
  homepage "https://github.com/sander-ed/gnosis"
  url "https://github.com/sander-ed/gnosis.git",
      tag:      "v0.3.0",
      revision: "964c69dd2f01d3a5d2cf91296887cd24b6f0cf95"

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
