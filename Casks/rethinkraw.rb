cask "rethinkraw" do
  version "0.10.2"
  sha256 "2585213417c8655644308359a4506cba2c24a8d04e1858da7d942d2b36ca009e"
  url "https://github.com/ncruces/RethinkRAW/releases/download/v#{version}/RethinkRAW.dmg"
  name "RethinkRAW"
  desc "RAW photo editor"
  homepage "https://rethinkraw.com/"

  depends_on cask: "adobe-dng-converter"

  app "RethinkRAW.app"

  postflight do
    # Remove quarantine attribute.
    system "xattr", "-dr", "com.apple.quarantine", "#{appdir}/RethinkRAW.app"
  end

  caveats "RethinkRAW requires Google Chrome or Microsoft Edge."
end
