class Gnosis < Formula
  desc "Git-backed OKF package manager"
  homepage "https://github.com/sander-ed/gnosis"
  url "ssh://git@github.com/sander-ed/gnosis.git",
      tag:      "v0.1.0",
      revision: "0418415c11cd89af1bfdbf0953bd58e55653d22c"

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
