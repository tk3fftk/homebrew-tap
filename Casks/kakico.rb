cask "kakico" do
  version "0.1.0"
  sha256 "183ae6e497ee5ff9c7658d792c5ecb2907e028c2240a19948f13c60b3128c868"

  url "https://github.com/tk3fftk/kakico/releases/download/v#{version}/Kakico-#{version}.zip"
  name "Kakico"
  desc "Screenshot annotation app for macOS"
  homepage "https://github.com/tk3fftk/kakico"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sequoia"
  depends_on arch: :arm64

  app "Kakico.app"

  # Kakico is ad-hoc signed (no Apple Developer ID, not notarized). On Apple
  # Silicon, a quarantined ad-hoc-signed app is rejected by Gatekeeper with a
  # misleading "app is damaged" dialog, so remove the quarantine attribute.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Kakico.app"]
  end

  zap trash: [
    "~/Library/Preferences/io.github.tk3fftk.kakico.plist",
    "~/Library/Saved Application State/io.github.tk3fftk.kakico.savedState",
  ]

  caveats <<~EOS
    Kakico is ad-hoc signed and not notarized. The quarantine attribute
    is removed automatically on install; if macOS still refuses to open:
      xattr -dr com.apple.quarantine "#{appdir}/Kakico.app"
  EOS
end
