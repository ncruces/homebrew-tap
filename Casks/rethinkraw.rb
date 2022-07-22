cask "rethinkraw" do
  version "0.8.1"
  sha256 "038e5920bac1bc9130ad15603be79588553dc066396b2b7d7e07a37e71e10405"

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
