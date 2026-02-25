class RunbooksAT060 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.6.0"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.6.0/runbooks_darwin_arm64"
      sha256 "2d7fde0e3777be723ef62350978d348765eb35670aaddba87bcbcb9e7d2cc996"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.6.0/runbooks_darwin_amd64"
      sha256 "6c3567889bc1289071c6ff3352a91d5d5c7f391a8f07ce83ed7a0eefe2574085"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.6.0/runbooks_linux_arm64"
      sha256 "61e8ef81d0bfc32988f85d3d2f0a41e9658937aef997503503596e006d5ae53a"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.6.0/runbooks_linux_amd64"
      sha256 "e856355f0d081904a651bc2f25227329deacc73449a94e005f747d04d3b10df5"
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
