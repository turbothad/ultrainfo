module ChromeForTesting
  CACHE_PATTERNS = [
    "~/.cache/selenium/chrome/*/*/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing",
    "~/.cache/selenium/chrome/*/*/chrome",
    "~/.cache/puppeteer/chrome/*/chrome-mac-*/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing",
    "~/.cache/puppeteer/chrome/*/chrome-linux*/chrome"
  ].freeze
  MACOS_APPLICATIONS = [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
  ].freeze

  def self.binary
    configured_binary = [ ENV["ULTRAINFO_CHROME_BIN"], ENV["CHROME_BIN"] ].compact.find { |path| File.executable?(path) }
    return configured_binary if configured_binary

    cached_browsers = CACHE_PATTERNS.flat_map { |pattern| Dir.glob(File.expand_path(pattern)).sort.reverse }
    candidates = cached_browsers + MACOS_APPLICATIONS
    candidates.find { |path| File.executable?(path) }
  end
end
