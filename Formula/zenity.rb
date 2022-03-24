class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "5ec4a893744bd5e3a6f10f37f18b4d768ac01006cbe9f7333f09ef61413ba333"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/zenity-0.7.14"
    sha256 cellar: :any_skip_relocation, big_sur:      "7f2b44f51e036da49b351cd6dd8e300eb61504c5e0c3209b7a793a2f77baec5c"
    sha256 cellar: :any_skip_relocation, catalina:     "023703432cb7453369d35ed4d595201ec830026638b842a101b21797069ff65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd1fd1085178bc2b50cc6ec6dec779422cde84f00c84f49a7c816de11c1bb337"
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
      system "go", "build", "-ldflags=-s -w -X main.tag=v0.7.14", "-trimpath", "-o", target, "./cmd/zenity"
    end
  end

  test do
    # CI is not WSL, so can't run the test.
    return if OS.linux? && ENV.include?("CI")

    system "#{bin}/zenity --progress --auto-close </dev/null"
  end
end
