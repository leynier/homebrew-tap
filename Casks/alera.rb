cask "alera" do
  version "0.50.0"
  sha256 "fb2ccfa121fecaab1954a3854cdbca605798d973a17f22e50c4208aa9bef034f"

  url "https://github.com/leynier/alera/releases/download/v#{version}/alera-#{version}-macos.tar.gz",
      verified: "github.com/leynier/alera/"
  name "Alera"
  desc "Native agentic development environment for terminals, worktrees, and CLI agents"
  homepage "https://alera.build/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # CI builds the macOS app on an Apple Silicon runner only, and the app targets
  # macOS 14. Claiming more would install a bundle that cannot run.
  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "Alera.app"

  # Homebrew quarantines what it downloads and the release build is not
  # notarized yet, so without this Gatekeeper refuses to open the app at all.
  # Remove this block once Developer ID signing and notarization are configured.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Alera.app"],
                   sudo: false
  end

  uninstall quit: "dev.leynier.alera"

  zap trash: [
    "~/Library/Application Support/dev.leynier.alera",
    "~/Library/Caches/dev.leynier.alera",
    "~/Library/HTTPStorages/dev.leynier.alera",
    "~/Library/Preferences/dev.leynier.alera.plist",
    "~/Library/Saved Application State/dev.leynier.alera.savedState",
  ]
end
