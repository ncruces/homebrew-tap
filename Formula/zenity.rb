class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "eb7d77e06de7a2585a1c080313817f51c48be20a03908b79648c5ed7ffa5a2ad"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, big_sur:      "211cdeffecbf5d313d9fd0d38b8bf3e366b36ad6fac44db1f4973b4ef26fea7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2ac388c1fa5e54fc3ac56654328b18a5c14acaf6b18e45609bea3c46a4a1524e"
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
