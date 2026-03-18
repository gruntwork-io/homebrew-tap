class RunbooksAT082 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.8.2"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.2/runbooks_darwin_arm64"
      sha256 "0291887a75ae4bd3eb2c89b87b2a8e260ea2fb543c991dc3aadceab6cb0d3d90"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.2/runbooks_darwin_amd64"
      sha256 "a37e11dc37136aafe97d85c5378b511195dabf75e8d631df6eedabdffee215c3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.2/runbooks_linux_arm64"
      sha256 "f735b4560495fee78508262eaf1421ae4e6d6937c5f917070880a0bed36df271"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.8.2/runbooks_linux_amd64"
      sha256 "6a2aed824c0e2f0676db1e8f9dd8a0995fd5dba9f6d71012242580bfd09bbe41"
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
