cask "kakico" do
  version "0.1.3"
  sha256 "8044a0b9654e272d471d7125f0123d95d67c76b4df59b7ecdf817cd8b002c397"

  url "https://github.com/tk3fftk/kakico/releases/download/v#{version}/Kakico-#{version}.zip"
  name "Kakico"
  desc "Screenshot annotation app for macOS"
  homepage "https://github.com/tk3fftk/kakico"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia
  depends_on arch: :arm64

  app "Kakico.app"

  # Kakico is ad-hoc signed (no Apple Developer ID, not notarized). On Apple
  # Silicon, a quarantined ad-hoc-signed app is rejected by Gatekeeper with a
  # misleading "app is damaged" dialog, so remove the quarantine attribute.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Kakico.app"]
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
