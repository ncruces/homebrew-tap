class Zenity < Formula
  desc "Dialog boxes for the command-line"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"

  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "7a90dff65a66a938a124647a91077b87a0300e479ed29f40a9226cafeb3049db"
  head "https://github.com/ncruces/zenity"

  bottle do
    root_url "https://github.com/ncruces/homebrew-tap/releases/download/v0.0.0"
    sha256 cellar: :any_skip_relocation, big_sur: "2ac7b0e30b9f629fc69b5a38e96d001c044e42c2ba2d36b982a21a929fc4553a"
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
