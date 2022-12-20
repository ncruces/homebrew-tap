cask "rethinkraw" do
  version "0.10.3"
  sha256 "7db7b28d15d707e5ee614253d2216c92cb671b7437110dac8e244549f97f6527"
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
