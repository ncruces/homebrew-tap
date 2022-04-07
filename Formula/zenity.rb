class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/homebrew-tap/releases/download/zenity-0.8.2/zenity_brew.zip"
  sha256 "f0f5efa58124236564a8a5a051257d2b5e5d8b1ec78ed1a8cc80d25fa3f33072"
  license "MIT"

  # Can't get this to work for the custom tap. Why?
  # conflicts_with "homebrew/core/zenity"

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
