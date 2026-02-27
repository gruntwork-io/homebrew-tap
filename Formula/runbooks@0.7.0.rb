class RunbooksAT070 < Formula
  desc "Interactive markdown documents that unlock the knowledge of subject matter experts"
  homepage "https://github.com/gruntwork-io/runbooks"
  version "beta-v0.7.0"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.0/runbooks_darwin_arm64"
      sha256 "6a90e813571e46f3fb45e314c9ab5f694891a768010ba289871eda9c54a8cdf8"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.0/runbooks_darwin_amd64"
      sha256 "7d1fe533b75de7c351327a1d9ddefc4ab0c9ae4bb81fdac2db1ae3e46e32d3bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.0/runbooks_linux_arm64"
      sha256 "0cbec5c633a38f73d6b2834ed74ffb86df1bd43e2afa02aea1d3dd40bd7ec82e"
    else
      url "https://github.com/gruntwork-io/runbooks/releases/download/beta-v0.7.0/runbooks_linux_amd64"
      sha256 "91604aad4e614831cdc441550f788478fe98370eed68f374258a7403b57c95f3"
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
