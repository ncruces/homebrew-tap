class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/releases/download/v0.10.10/zenity_brew.zip"
  sha256 "9c2dfb9472bac11811cc4a77b7bdafaf973f28b588435d69ebd69d5f14603df6"
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
