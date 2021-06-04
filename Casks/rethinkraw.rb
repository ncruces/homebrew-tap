cask "rethinkraw" do
  version "v0.6.0"
  sha256 "797f4b796b94833382179712759295331a0663464ae46246f0d4d209f80e3876"

  url "https://rethinkraw.com/releases/download/#{version}/RethinkRAW.dmg"
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
