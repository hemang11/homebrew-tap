# typed: strict
# frozen_string_literal: true

# BASH_GOD packages searchable local command memory for reviewed native operations.
class BashGod < Formula
  desc "Searchable local command memory for reviewed native operations"
  homepage "https://github.com/hemang11/BASH-GOD"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3/bash-god-0.0.3-darwin-arm64.tar.gz"
      sha256 "2dc48bccacb5b38bc0e591e1d87e167a4673186fd0b0b1fc3ca5f2ed1449e113"
    end

    on_intel do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3/bash-god-0.0.3-darwin-amd64.tar.gz"
      sha256 "29dd1e306c5d26068bc33741387de292bf685a462ea07feff16a50843a5cb77f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3/bash-god-0.0.3-linux-arm64.tar.gz"
      sha256 "7d52ff2bf1d3ba031b24ab884431642dfb5e9c7003ad0af3f948583d4639fd8c"
    end

    on_intel do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3/bash-god-0.0.3-linux-amd64.tar.gz"
      sha256 "9e9808651f4dbb63c4a7195386a54ca37e2455b51dd47f2f5c528f01fc0dd2ff"
    end
  end

  def install
    target = if OS.mac?
      Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"
    else
      Hardware::CPU.arm? ? "linux-arm64" : "linux-amd64"
    end
    package_root = "bash-god-#{version}-#{target}"
    source_root = if Dir.exist?(package_root)
      package_root
    elsif (buildpath/"bin").directory? && (buildpath/"lib/bash-god/god").executable?
      "."
    else
      odie "missing BASH_GOD runtime directory: #{package_root}"
    end
    libexec.install Dir.children(source_root).map { |entry| "#{source_root}/#{entry}" }
    bin.install_symlink libexec/"bin/god"
  end

  test do
    assert_match "BASH_GOD #{version}", shell_output("#{bin}/god --version")
    assert_match "GENERAL COMMANDS", shell_output("#{bin}/god general --quiet")
  end
end
