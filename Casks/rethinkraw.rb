cask "rethinkraw" do
  version "0.10.5"
  sha256 "cd770eb652f0bf6bf40878f3f7ff18032c0d522d5263083e9065a4fbee6faf51"
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
