cask "rethinkraw" do
  version "0.7.0"
  sha256 "936d91f98922af69e71378ad746921b70282fa5f9b923824e4f228429b489a92"

  url "https://rethinkraw.com/releases/download/v#{version}/RethinkRAW.dmg"
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
