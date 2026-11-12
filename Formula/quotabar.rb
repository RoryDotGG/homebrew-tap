class Quotabar < Formula
  desc "Claude plan usage in the macOS menu bar"
  homepage "https://github.com/RoryDotGG/QuotaBar"
  license "MIT"
  url "https://github.com/RoryDotGG/QuotaBar.git",
      tag:      "v1.3.0",
      revision: "8e9e001563ec26da33a49a0b1f88a6b30450381d"
  head "https://github.com/RoryDotGG/QuotaBar.git", branch: "main"

  depends_on macos: :sonoma

  def install
    system "./build.sh"
    prefix.install "QuotaBar.app"
  end

  # `open -n -W` hands the app to LaunchServices and waits while it runs, so brew
  # sees the service as started, yet `brew services stop` only ends the wait and
  # never kills the app. opt_prefix is stable across upgrades, unlike the Cellar path.
  service do
    run ["/usr/bin/open", "-n", "-W", opt_prefix/"QuotaBar.app"]
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
