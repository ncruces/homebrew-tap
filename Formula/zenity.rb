class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "91ed34582be5c5f23792cb1a0442e3deb8f944e44b8ae77bd934367f4f2af97f"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/zenity-0.7.8"
    sha256 cellar: :any_skip_relocation, big_sur:      "fca6af7866102443e1eac5963cbfe01b46ec17b8ccb9ccfb217fc495d1c394c9"
    sha256 cellar: :any_skip_relocation, catalina:     "e248a01ee026064b6408230babcd28aa5f5e0bd76ff01e18edfb7d94e4968864"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8c90527ce9cb43daafd7f729bda8b813d8f60cab3c1f595e8c66b7ed0114d878"
  end

  depends_on "go" => :build

  # Can't get this to work for the custom tap. Why?
  # conflicts_with "homebrew/core/zenity"

  if OS.linux? && File.readlines("/proc/version").grep(/microsoft/i).empty? && ENV.exclude?("CI")
    odie "This formula is only available on macOS and WSL."
  end

  def install
    ENV["GOPATH"] = buildpath

    target = bin/"zenity"
    if OS.linux?
      # We're either on WSL or CI.
      # Build the Windows version and wrap for WSL.
      ENV["GOOS"] = "windows"
      target = libexec/"zenity.exe"
      (bin/"zenity").write_env_script target, "--unixeol --wslpath", {}
    end

    bin_path = buildpath/"src/github.com/ncruces/zenity"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", "-ldflags=-s -w", "-trimpath", "-o", target, "./cmd/zenity"
    end
  end

  test do
    # CI is not WSL, so can't run the test.
    return if OS.linux? && ENV.include?("CI")

    system "#{bin}/zenity --progress --auto-close </dev/null"
  end
end
