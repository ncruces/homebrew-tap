class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/releases/download/v0.10.4/zenity_brew.zip"
  sha256 "5d2cb14e5e1ef0a60743356c4adf7308f22434850bb565cc1020d3528595bed9"
  license "MIT"

  on_linux do
    if File.readlines("/proc/version").grep(/microsoft/i).empty?
      odie "This formula is only available on macOS and WSL."
    end
  end

  def install
    mkdir_p bin

    if OS.linux?
      # We're on WSL.
      # Get the Windows version and wrap for WSL.
      mkdir_p libexec
      cp "zenity.exe", libexec/"zenity.exe"
      (bin/"zenity").write_env_script libexec/"zenity.exe", "--unixeol --wslpath", {}
    else
      cp "zenity", bin/"zenity"
    end
  end

  test do
    system "#{bin}/zenity --progress --auto-close </dev/null"
  end
end
