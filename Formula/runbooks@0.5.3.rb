class RunbooksAT053 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.5.3"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.3/runbooks_darwin_arm64"
      sha256 "1123d01cafae7bc75352762cbf421347411d935e3ede9d5f0f33e836e416768b"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.3/runbooks_darwin_amd64"
      sha256 "87dca4f981c5b6ab88837003ab5e8a8499bd77d0482b284662e1e8cd0d3818fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.3/runbooks_linux_arm64"
      sha256 "c49d53296c2eca38c93a946145d2879c5da6556df6d84c6d52dc84cc292a86ab"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.3/runbooks_linux_amd64"
      sha256 "0224bfb1cf6e7cf054657f017b4c3e792664ab110eee226ead2cafcdcc930d11"
    end
  end

  def install
    binary = Dir["runbooks_*"].first
    bin.install binary => "runbooks"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runbooks version")
  end
end
