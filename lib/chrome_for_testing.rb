module ChromeForTesting
  CACHE_PATTERN = "~/.cache/puppeteer/chrome/*/chrome-mac-*/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing"

  def self.binary
    configured_binary = ENV["CHROME_BIN"]
    return configured_binary if configured_binary && !configured_binary.empty?

    Dir.glob(File.expand_path(CACHE_PATTERN)).sort.last
  end
end
