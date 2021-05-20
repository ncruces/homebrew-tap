class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "7a90dff65a66a938a124647a91077b87a0300e479ed29f40a9226cafeb3049db"
  head "https://github.com/ncruces/zenity"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/ncruces/zenity"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/kevinburke/hostsfile
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "build", "-ldflags=-s -w", "-trimpath", "-o", bin/"zenity", "./cmd/zenity"
    end
  end
end
