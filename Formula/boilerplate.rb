class Boilerplate < Formula
  desc "The template generator built for platform teams"
  homepage "https://boilerplate.gruntwork.io/"
  version "v0.12.0-alpha1"
  license "MPL-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.12.0-alpha1/boilerplate_darwin_arm64"
      sha256 "669ec46e69e608465bdc781d0dd1906ff916a2fd06682f5da88c57584d845921"
    else
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.12.0-alpha1/boilerplate_darwin_amd64"
      sha256 "44e401006bf460a97641dd6aca4e00456526c1349bc1f26da73633f32804090b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.12.0-alpha1/boilerplate_linux_arm64"
      sha256 "af0dd7256c951efe237f5ce47c0b2dc22bc6e0355691b261088113fe0a648ff3"
    else
      url "https://github.com/gruntwork-io/boilerplate/releases/download/v0.12.0-alpha1/boilerplate_linux_amd64"
      sha256 "dd5e1b587fd7db8b5e4cd6e444d1b7ef932bc2d9d252cb3dc21be1979182350d"
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
