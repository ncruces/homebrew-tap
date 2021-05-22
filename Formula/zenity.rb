class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "178f759225b1385f45bd4dfbd52a4672cc28b7b55566c7b42d49ae5cf418e71b"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/v0.0.0"
    sha256 cellar: :any_skip_relocation, big_sur: "2c4811550cbc5a164f6b8a3b40d96b651bba51a9ebd7f3dccf4a8ca0c7ded109"
  end

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
