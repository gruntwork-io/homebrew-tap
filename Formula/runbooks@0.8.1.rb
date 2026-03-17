class RunbooksAT081 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.8.1"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.1/runbooks_darwin_arm64"
      sha256 "473f43982cc5ada2639159abe28cfd71c1324f80268912ec5b46dabd5446a224"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.1/runbooks_darwin_amd64"
      sha256 "a4c6bdd90d25de4ce243e1fc2f3c8c9591f867772bff2953424535730682f57b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.1/runbooks_linux_arm64"
      sha256 "7f64c88e0f2e714e58da91808da28a98309a315f13441cbfdc2d36d4299cd6ea"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.1/runbooks_linux_amd64"
      sha256 "00659a389f6437405e8b21c636e7e2bc96909261183f87664bab272d4613029a"
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
