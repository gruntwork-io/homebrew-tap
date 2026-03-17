class RunbooksAT080 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.8.0"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.0/runbooks_darwin_arm64"
      sha256 "17805803ddfee557e48643f85da8cdef8eb8390729e837736148bf591c6b6c81"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.0/runbooks_darwin_amd64"
      sha256 "89db9d85e725d5762bf7ec659c3856fa63e08c5589b24aca74861e60f4d7a6db"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.0/runbooks_linux_arm64"
      sha256 "6efaaafae11c228b80eb605612b15a5bb5afc7f4982ddb191ae4f707fc59f8bb"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.0/runbooks_linux_amd64"
      sha256 "752de037df4a6369e5e9ad8d8ee8d0de82316e7ef46d86e84395a440deab1c9e"
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
