cask "rethinkraw" do
  version "0.10.0"
  sha256 "5e3ee0c8f1e1056205735a86b586387a2a687cd6eba3c6dc1db3049edbb42582"
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
