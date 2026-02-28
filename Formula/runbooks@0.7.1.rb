class RunbooksAT071 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.7.1"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.1/runbooks_darwin_arm64"
      sha256 "3786aab2e3d61bbf5ef58d7b01ed5ae98368196e624e2f5479f57461b6eac5bc"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.1/runbooks_darwin_amd64"
      sha256 "9f9f206653d69d9626b3962979866c2cf8e87a4273b8eeab4033914390c659d9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.1/runbooks_linux_arm64"
      sha256 "21a3384846efbc38627a3f32d5bd4c9dd74c4287d69b9edb2ad450dc41198147"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.1/runbooks_linux_amd64"
      sha256 "e8413f8376cfd0dbf0d3647d30b3cbdfeed6a204dbc912ac75adea71891df3a3"
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
