class Quotabar < Formula
  desc "Claude plan usage in the macOS menu bar"
  homepage "https://github.com/RoryDotGG/QuotaBar"
  url "https://github.com/RoryDotGG/QuotaBar.git",
      tag:      "v1.0.0",
      revision: "943f583c8bf055ac847949c066fdf3cacf56f294"
  head "https://github.com/RoryDotGG/QuotaBar.git", branch: "main"

  depends_on macos: :sonoma

  def install
    system "./build.sh"
    prefix.install "QuotaBar.app"
  end

  def caveats
    <<~EOS
      Start it:
        open #{opt_prefix}/QuotaBar.app

      Then use the ⋯ menu for "Open at login".

      QuotaBar reads Claude Code's sign-in from the keychain, so the
      Claude Code CLI must be installed and signed in (claude auth login).
    EOS
  end

  test do
    assert_predicate prefix/"QuotaBar.app/Contents/MacOS/QuotaBar", :executable?
    system "codesign", "--verify", prefix/"QuotaBar.app"
  end
end
