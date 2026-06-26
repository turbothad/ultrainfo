# Screenshot a URL with a real headless-Chrome event loop (so JS/fetch/Leaflet actually render).
# Usage: bundle exec ruby script/shot.rb <url> <out.png> [wait_seconds]
require "selenium-webdriver"

url  = ARGV[0] or abort "usage: ruby script/shot.rb <url> <out.png> [wait]"
out  = ARGV[1] || "tmp/screens/out.png"
wait = (ARGV[2] || "4").to_f

chrome = Dir.glob(File.expand_path(
  "~/.cache/puppeteer/chrome/*/chrome-mac-*/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing"
)).sort.last or abort "no Chrome for Testing under ~/.cache/puppeteer"

opts = Selenium::WebDriver::Chrome::Options.new
opts.binary = chrome
opts.add_argument("--headless=new")
opts.add_argument("--window-size=1280,1700")
opts.add_argument("--hide-scrollbars")
opts.add_argument("--force-device-scale-factor=1")

driver = Selenium::WebDriver.for(:chrome, options: opts)
begin
  driver.navigate.to(url)
  sleep wait # let fetch + Leaflet tiles/vectors paint
  require "fileutils"
  FileUtils.mkdir_p(File.dirname(out))
  driver.save_screenshot(out)
  puts "wrote #{out}"
ensure
  driver.quit
end
