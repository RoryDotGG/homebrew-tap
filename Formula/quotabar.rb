class Quotabar < Formula
  desc "Claude plan usage in the macOS menu bar"
  homepage "https://github.com/RoryDotGG/QuotaBar"
  url "https://github.com/RoryDotGG/QuotaBar.git",
      tag:      "v1.1.0",
      revision: "6d9334ee457023585d256d56784599a9336e5d45"
  head "https://github.com/RoryDotGG/QuotaBar.git", branch: "main"

  depends_on macos: :sonoma

  def install
    system "./build.sh"
    prefix.install "QuotaBar.app"
  end

  # `open -n` hands the app to LaunchServices and exits, so `brew services stop`
  # only removes the login item; it never kills a running copy. opt_prefix is
  # stable across upgrades, unlike the versioned Cellar path.
  service do
    run ["/usr/bin/open", "-n", opt_prefix/"QuotaBar.app"]
    run_type :immediate
    keep_alive false
  end

  def caveats
    <<~EOS
      Start it now and at every login:
        brew services start quotabar

      It keeps an alias at ~/Applications/QuotaBar.app so Spotlight and
      Raycast can find it.

      QuotaBar reads Claude Code's sign-in from the keychain, so the
      Claude Code CLI must be installed and signed in (claude auth login).
    EOS
  end

  test do
    assert_predicate prefix/"QuotaBar.app/Contents/MacOS/QuotaBar", :executable?
    system "codesign", "--verify", prefix/"QuotaBar.app"
  end
end
