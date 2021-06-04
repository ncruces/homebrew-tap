class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "178f759225b1385f45bd4dfbd52a4672cc28b7b55566c7b42d49ae5cf418e71b"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/v0.0.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "2c4811550cbc5a164f6b8a3b40d96b651bba51a9ebd7f3dccf4a8ca0c7ded109"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e2e60408eda6da891d797c0b238b8d5dc73d64a050a16664c589e166409b1e7b"
  end

  depends_on "go" => :build

  if OS.linux? && File.readlines("/proc/version").grep(/microsoft/i).empty?
    odie "This formula is only available on macOS and WSL."
  end

  def install
    ENV["GOPATH"] = buildpath

    target = bin/"zenity"
    if OS.linux?
      # On WSL.
      ENV["GOOS"] = "windows"
      target = libexec/"zenity.exe"
    end

    bin_path = buildpath/"src/github.com/ncruces/zenity"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", "-ldflags=-s -w", "-trimpath", "-o", target, "./cmd/zenity"
    end

    if OS.linux?
      # Create WSL wrapper script.
      (bin/"zenity").write_env_script target, "--unixeol --wslpath", {}
    end
  end
end
