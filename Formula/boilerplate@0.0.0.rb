class BoilerplateAT000 < Formula
  desc "The template generator built for platform teams"
  homepage "https://boilerplate.gruntwork.io/"
  version "v0.0.0-test-signing"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.0.0-test-signing/boilerplate_darwin_arm64"
      sha256 "937a4a1a836b56dbe2f09acef7c6dc2e5f27d044c847e9367115df4f3b6d37e2"
    else
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.0.0-test-signing/boilerplate_darwin_amd64"
      sha256 "f58b9de7ca1cf09d827935c480c8e3c64e11bad9bf5e71b9e97480ef9e5f0e5a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.0.0-test-signing/boilerplate_linux_arm64"
      sha256 "c435a58c3faf10eed02780909f3a81c402c77b2c5fcd8524befbd23ae09ff363"
    else
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.0.0-test-signing/boilerplate_linux_amd64"
      sha256 "aa27c9213f1d87824d847a2bec1c7aed65a7c27fbbcc0232ef003ab7d4563fa2"
    end
  end

  def install
    binary = Dir["boilerplate_*"].first
    bin.install binary => "boilerplate"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/boilerplate --version")
  end
end
