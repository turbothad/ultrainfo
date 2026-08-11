# Capture a full-page screenshot after client-side maps and data have rendered.
# Usage: bundle exec ruby script/shot.rb <url> <out.png> [wait_seconds] [width]
require "fileutils"
require "selenium-webdriver"
require_relative "../lib/chrome_for_testing"

url = ARGV[0] or abort "usage: ruby script/shot.rb <url> <out.png> [wait] [width]"
out = ARGV[1] || "tmp/screens/out.png"
wait = (ARGV[2] || "4").to_f
width = (ARGV[3] || "1280").to_i

options = Selenium::WebDriver::Chrome::Options.new
options.binary = ChromeForTesting.binary if ChromeForTesting.binary
options.add_argument("--headless=new")
options.add_argument("--hide-scrollbars")
options.add_argument("--force-device-scale-factor=1")

driver = Selenium::WebDriver.for(:chrome, options: options)
begin
  mobile = width < 600
  viewport = { width: width, height: 900, deviceScaleFactor: 1, mobile: mobile }
  if mobile
    driver.execute_cdp("Emulation.setDeviceMetricsOverride", **viewport)
  else
    driver.manage.window.resize_to(width, 900)
  end
  driver.navigate.to(url)
  sleep wait

  height = driver.execute_script(<<~JS)
    return Math.max(
      document.body.scrollHeight,
      document.documentElement.scrollHeight,
      document.body.offsetHeight,
      document.documentElement.offsetHeight
    )
  JS
  full_height = [ height.to_i, 12_000 ].min
  if mobile
    driver.execute_cdp("Emulation.setDeviceMetricsOverride", **viewport.merge(height: full_height))
  else
    driver.manage.window.resize_to(width, full_height)
  end
  sleep 0.25

  FileUtils.mkdir_p(File.dirname(out))
  driver.save_screenshot(out)
  puts "wrote #{out}"
ensure
  driver.quit
end
