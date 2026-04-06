class RunbooksAT090 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.9.0"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.9.0/runbooks_darwin_arm64"
      sha256 "717c3632e790e0db34647ccba88c01928555f69ad9155dcd90afa5450f7d9af5"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.9.0/runbooks_darwin_amd64"
      sha256 "4c5de03d781b65f4943fc1aecedb2d199a516cad3b42e53525956b673786965b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.9.0/runbooks_linux_arm64"
      sha256 "329fb81f0718eb4ee93b5b377ed620e88ebedde90e074196858953ad685b2343"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.9.0/runbooks_linux_amd64"
      sha256 "b14da2fc8c2192c7d06dd8168e486c74ec3d4f7fcb9faa67e59c0ab6e3749f58"
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
