require "test_helper"
require_relative "../lib/chrome_for_testing"

Selenium::WebDriver::Chrome::Service.driver_path = ENV["CHROMEDRIVER_PATH"] if ENV["CHROMEDRIVER_PATH"].present?

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |options|
    options.binary = ChromeForTesting.binary if ChromeForTesting.binary
    # The site smooth-scrolls (html { scroll-behavior: smooth }), which races
    # chromedriver's pre-click scroll and intercepts clicks on slow runners.
    # Forcing reduced motion engages the site's own scroll-behavior: auto path.
    options.add_argument("--force-prefers-reduced-motion")
  end
end
