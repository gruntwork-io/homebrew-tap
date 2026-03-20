class RunbooksAT083 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.8.3"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.3/runbooks_darwin_arm64"
      sha256 "6ee11e15f1e361a689642dd83bc2bd7285efd31afba41f8224cc3e978504597c"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.3/runbooks_darwin_amd64"
      sha256 "3346c45f73c9c0b532397885d59d0ef27d190281ce058ee9857d3243da8780b8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.3/runbooks_linux_arm64"
      sha256 "1bbe96c2a36bfac43cca985be52c9cb0c993ba1853a0e15bbc1e0a0a464d0bd0"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.3/runbooks_linux_amd64"
      sha256 "35ff24acb141975902bbb8a29b47d3feb2701c71d157416272773ec8c1778c1c"
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
