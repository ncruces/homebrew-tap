class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "98ede20e3153b588e3442aa99cf0011a9aa2ccd4fa0a482ce9fbe3150b2fa912"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/zenity-0.7.12"
    sha256 cellar: :any_skip_relocation, big_sur:      "e95dae8718f23bb6a8df2721c3b1f7cae9c62f90508cda3f6bdfedacb0a46b3f"
    sha256 cellar: :any_skip_relocation, catalina:     "16dacfa73cac2d7930b679a816340428e75c7032490fe5179732f9685fff62e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "312d4a6707e9e438692e0c9bbb7394005c25a1d7a5ff4114a2f758d3c6d27855"
  end

  depends_on "go" => :build

  # Can't get this to work for the custom tap. Why?
  # conflicts_with "homebrew/core/zenity"

  on_linux do
    if File.readlines("/proc/version").grep(/microsoft/i).empty? && ENV.exclude?("CI")
      odie "This formula is only available on macOS and WSL."
    end
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
      system "go", "build", "-ldflags=-s -w -X main.tag=v0.7.12", "-trimpath", "-o", target, "./cmd/zenity"
    end
  end

  test do
    # CI is not WSL, so can't run the test.
    return if OS.linux? && ENV.include?("CI")

    system "#{bin}/zenity --progress --auto-close </dev/null"
  end
end
