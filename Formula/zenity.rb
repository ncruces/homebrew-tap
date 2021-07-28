class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "91ed34582be5c5f23792cb1a0442e3deb8f944e44b8ae77bd934367f4f2af97f"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/zenity-0.7.7"
    sha256 cellar: :any_skip_relocation, big_sur:      "22aa72a9a7dbf96f6a4e04a0ccc8e052285e572be97c47aa86709f9ff88b728b"
    sha256 cellar: :any_skip_relocation, catalina:     "e0a95dcddf8f8048c1f02240be5298e96a648b1c6dd579fc8bfc3808ebf7bc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ea5d99f9a020ff5a8ab5c4ba635d44469c19d31fa68e6d7039bd99f5d907691"
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
