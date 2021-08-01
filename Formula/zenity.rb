class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "db5f320db0ac372ef6010dc77fb406eb5b6c6da0b4d5730ad2e870c83db54960"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/zenity-0.7.9"
    sha256 cellar: :any_skip_relocation, big_sur:      "fdc0e372c82097f78ba50dc87ea607829057af430fcc29a11340263c403931e8"
    sha256 cellar: :any_skip_relocation, catalina:     "2af7d76e4ae2e8d70a8d649c0db98072ae40b7e1d4c1b0e590b4fdd88ca77dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e9124189c567b287ed8a9f9f5768bfd7c4f2d414aeb32b811ab7f5154034910"
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
