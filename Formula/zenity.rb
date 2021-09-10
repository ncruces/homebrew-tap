class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "98ede20e3153b588e3442aa99cf0011a9aa2ccd4fa0a482ce9fbe3150b2fa912"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/zenity-0.7.10"
    sha256 cellar: :any_skip_relocation, big_sur:      "b94c8dd1ef88597c038be1bb2133981703645922a82ae07fe7f5791729b889f8"
    sha256 cellar: :any_skip_relocation, catalina:     "90ab75bf0704c37eeb4b7bff77892593add88a4c8511a5773b722cc5a5cbeb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c7a85a0583cfe970fee5a61f1d6bb098203b68f871812672014c2fe701a34be0"
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
