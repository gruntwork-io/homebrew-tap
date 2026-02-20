class Runbooks < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.5.2"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.2/runbooks_darwin_arm64"
      sha256 "2a2f5ba50058a807d1aa8e7fc361eabf66d0a003e828768171697b1dea16e7ae"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.2/runbooks_darwin_amd64"
      sha256 "75ea3db567f9a328b5304472a1022f89b8736a6849fe92c17a56926ba70cedc0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.2/runbooks_linux_arm64"
      sha256 "bcff4d194e19dde98852fab1710a26fa265e4ca27ddeff6d352ed472fe9bcb3a"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.5.2/runbooks_linux_amd64"
      sha256 "35996b638b8b1db0010bcf9d96f3236804f6b59b950a2f95d7c92cd562d9f8ab"
    end
  end

  def install
    binary = Dir["runbooks_*"].first
    bin.install binary => "runbooks"
  end

  test do
    assert_match "beta-v0.5.2", shell_output("#{bin}/runbooks version")
  end
end
