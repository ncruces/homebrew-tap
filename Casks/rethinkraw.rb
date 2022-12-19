cask "rethinkraw" do
  version "0.10.1"
  sha256 "bdb01d1c19d48158c2a2942c8c52dbdeb3b499e695a89cb245aed22f9dac5754"
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
