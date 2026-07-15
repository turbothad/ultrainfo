# Screenshot a URL with a real headless-Chrome event loop (so JS/fetch/terrain render).
# Usage: bundle exec ruby script/shot.rb <url> <out.png> [wait_seconds] [full]
require "selenium-webdriver"
require_relative "../lib/chrome_for_testing"

url  = ARGV[0] or abort "usage: ruby script/shot.rb <url> <out.png> [wait_seconds] [full]"
out  = ARGV[1] || "tmp/screens/out.png"
wait = (ARGV[2] || "4").to_f
full_page = ARGV[3] == "full"

chrome = ChromeForTesting.binary or abort "no Chrome for Testing under ~/.cache/puppeteer"

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
  if full_page
    height = driver.execute_script(<<~JAVASCRIPT)
      return Math.max(
        document.body.scrollHeight,
        document.documentElement.scrollHeight,
        document.body.offsetHeight,
        document.documentElement.offsetHeight
      )
    JAVASCRIPT
    driver.manage.window.resize_to(1280, height)
  end
  require "fileutils"
  FileUtils.mkdir_p(File.dirname(out))
  driver.save_screenshot(out)
  puts "wrote #{out}"
ensure
  driver.quit
end
