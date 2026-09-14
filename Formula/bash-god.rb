# typed: strict
# frozen_string_literal: true

# BASH_GOD packages searchable local command memory for reviewed native operations.
class BashGod < Formula
  desc "Searchable local command memory for reviewed native operations"
  homepage "https://github.com/hemang11/BASH-GOD"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3.1/bash-god-0.0.3.1-darwin-arm64.tar.gz"
      sha256 "9ab704f88c29c6110b8b2e3969b4940d27f4c32d34ee706118ea2627ab1959cf"
    end

    on_intel do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3.1/bash-god-0.0.3.1-darwin-amd64.tar.gz"
      sha256 "cf5d80c248dd52cb59db2af138af5287c39cc871427ccea7a8776e6890bb6961"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3.1/bash-god-0.0.3.1-linux-arm64.tar.gz"
      sha256 "efe83cac53faf4e659f5b919ac1ac138b829c6d40d7dbf2380d937851ed1505b"
    end

    on_intel do
      url "https://github.com/hemang11/BASH-GOD/releases/download/v0.0.3.1/bash-god-0.0.3.1-linux-amd64.tar.gz"
      sha256 "314c4e5fd321cdb7e6920dc06e9aa11acf27f73f38c9fad90b82b39ac554274e"
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
    (libexec/"share/bash-god").mkpath
    (libexec/"share/bash-god/package-owner").write("homebrew\n")
    bin.install_symlink libexec/"bin/god"
  end

  post_install_steps do
    run "god", args: ["--resync"], base: :bin, env: { "GOD_COLOR" => "never" },
        must_succeed: false, print_stdout: false, print_stderr: false,
        writable_paths: [".local/state"], writable_base: :home
  end

  test do
    assert_match "BASH_GOD #{version}", shell_output("#{bin}/god --version")
    assert_match "GENERAL COMMANDS", shell_output("#{bin}/god general --quiet")
  end
end
