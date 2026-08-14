require "test_helper"
require "tmpdir"

module Events
  class ImportTest < ActiveSupport::TestCase
    test "publishes the version-controlled Active event catalog" do
      published_races = Import.new(Rails.root.join("db/events/active.yml")).call

      assert_equal [ "Bighorn 100", "Southern Tour Ultra", "HURT 100", "Long Haul 100", "Coldwater Rumble 100",
                     "The Shippey 100", "Forgotten Florida 100", "Rocky Raccoon 100", "Jackpot 100",
                     "Orcas Island 100", "LOViT 100", "The Drift 100", "Viper 100",
                     "The Pistol Ultra 100", "Warbird 100", "Bootlegger 100",
                     "Badger Mountain Challenge 100", "Crown Stub 100" ], published_races.map(&:name)
      race = published_races.find { |published| published.slug == "bighorn-100" }
      assert_equal 20_500, race.elevation_gain_ft
      assert_equal Date.new(2026, 6, 19), race.start_date
      assert_equal Date.new(2026, 6, 20), race.end_date
      assert race.closed?
      assert_nil race.lottery, "lottery status is unpublished by the reviewed first-party sources"
      assert_equal "https://bhtr.itsyourrace.com/Results.aspx?id=384", race.results_url
      assert_equal "warning", race.source_metadata["verification_status"]
      assert_equal 600, race.simplified_track.size
      assert_equal 22, race.aid_stations.count
      assert race.aid_stations.all?(&:coordinates?), "every Station pass gets coordinates from a course waypoint"
      assert_equal [ 1.25, 3.5, 8.5, 33.5, 40.0 ], race.aid_stations.where(has_water: true).pluck(:mile).map(&:to_f),
                   "only passes whose current page or course description names water are marked as listing it"
      assert race.aid_stations.all? { |station| station.potable_water.nil? },
             "listed water does not establish potability at any pass"
      station_source_urls = race.aid_stations.first.source_metadata.fetch("sources").pluck("url")
      assert_includes station_source_urls, "https://bighorntrailrun.com/100-mile"
      assert_includes station_source_urls,
                      "https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/downloads/30d8acf5-26bd-40cf-b6a4-a5ffefb537e2/Bighorn%20100%20Aid%20Station%20Chart.pdf?ver=1782760210683"
      assert_nil race.aid_stations.find_by!(mile: 13.5).has_water,
                 "water remains unspecified when the source only lists general drinks or aid"
      assert_match(/outbound pass/i, race.aid_stations.find_by!(mile: 13.5).source_metadata.fetch("source_notes"))
      assert_equal 5, race.aid_stations.count(&:drop_bag?),
                   "only the five pass-specific drop-bag accesses are counted"
      assert race.aid_stations.reject(&:drop_bag?).all? { |station| station.drop_bag.nil? },
             "other passes remain not listed rather than being reported as no"
      assert_equal "30h", race.aid_stations.find_by!(mile: 82.5).cutoff_elapsed_label
      assert_nil race.aid_stations.find_by!(mile: 100).has_medical,
                 "the official sources do not establish a finish-line medical check"
      assert_equal 4, race.aid_stations.count(&:has_medical?),
                   "only pass-specific scheduled medical checks are counted"
      assert_includes race.source_metadata.fetch("sources").pluck("url"),
                      "https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/2026%20BHTR%20SCHEDULE-fb5032e.pdf"
      assert_equal 4, race.crew_route["legs"].size
      assert_equal "Ultrainfo Routing::Osrm", race.crew_route.dig("provenance", "generator")
      assert_equal "2026-06-26", race.crew_route.dig("provenance", "generated_on")
      assert_equal Terrain::Artifact::SCHEMA_VERSION, race.terrain_artifacts.fetch("schema_version")
      assert_match(/\A[0-9a-f]{64}\z/, race.terrain_artifacts.fetch("sha256"))
      assert_equal race.slug, Terrain::Artifact.read(
        race.terrain_artifacts,
        from: Rails.root.join("public/terrain/bighorn-100.json"),
        race_slug: race.slug
      ).data.dig("race", "slug")

      southern_tour = published_races.find { |published| published.slug == "southern-tour-ultra" }
      assert_equal 2027, southern_tour.year
      assert_equal Date.new(2027, 1, 15), southern_tour.start_date
      assert_equal Date.new(2027, 1, 16), southern_tour.end_date
      assert southern_tour.open?
      assert_equal false, southern_tour.lottery,
                   "direct first-come RunSignup registration establishes there is no lottery"
      assert_equal 32, southern_tour.cutoff_hours
      assert_nil southern_tour.elevation_gain_ft,
                 "the organizer says only `primarily flat` and publishes no vert figure"
      assert_equal "warning", southern_tour.source_metadata["verification_status"]
      assert_equal 600, southern_tour.simplified_track.size
      assert_equal 21, southern_tour.aid_stations.count,
                   "a Start pass plus two passes on each of the ten 10-mile loops"
      assert southern_tour.aid_stations.all?(&:coordinates?), "every Station pass gets coordinates from a course waypoint"
      assert_equal 2, southern_tour.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "a loop race crosses the same two physical stations on every lap"
      assert_in_delta southern_tour.start_lat.to_f, southern_tour.finish_lat.to_f, 0.001,
                      "the organizer map draws one closed loop"
      assert southern_tour.aid_stations.all?(&:has_water?),
             "the Individual Events page lists water at both stations"
      assert southern_tour.aid_stations.all? { |station| station.potable_water.nil? },
             "listed water does not establish potability at any pass"
      assert_not southern_tour.aid_stations.find_by!(mile: 5).crew_accessible?,
                 "published crew provisions are all at the start/finish event field"
      assert_not southern_tour.aid_stations.find_by!(mile: 45).pacer_access?,
                 "pacer pickup is not guaranteed before mile 50"
      assert southern_tour.aid_stations.find_by!(mile: 50).pacer_access?,
             "pacing is allowed from mile 50 (or 11:59 PM Friday, whichever comes first)"
      assert_equal "29h", southern_tour.aid_stations.find_by!(mile: 90).cutoff_elapsed_label,
                   "the final lap must start by 5:00 PM Saturday"
      assert_equal "32h", southern_tour.aid_stations.find_by!(mile: 100).cutoff_elapsed_label
      assert_equal Time.find_zone("America/New_York").parse("2027-01-16 8:00 PM"), southern_tour.final_cutoff_at
      assert_includes southern_tour.source_metadata.fetch("sources").pluck("url"),
                      "https://runsignup.com/Race/SouthernTourUltra/Page/IndividualEvents"

      hurt = published_races.find { |published| published.slug == "hurt-100" }
      assert_equal 2027, hurt.year
      assert_equal Date.new(2027, 1, 16), hurt.start_date
      assert hurt.closed?, "the 2027 field was set by the August 8, 2026 lottery"
      assert_equal true, hurt.lottery
      assert_equal 36, hurt.cutoff_hours
      assert_equal 24_500, hurt.elevation_gain_ft, "the Book of HURT publishes cumulative gain per 100 miles"
      assert_equal 16, hurt.aid_stations.count,
                   "a Start pass plus three passes on each of the five nominal 20-mile laps"
      assert_equal 3, hurt.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "every lap crosses the same three physical stations"
      assert hurt.aid_stations.all? { |station| station.has_medical == false },
             "the Book of HURT states typical first-aid items are not provided at aid stations"
      assert hurt.aid_stations.select { |station| station.name.include?("Nuʻuanu") }.none?(&:crew_accessible?),
             "crew access is never allowed at Nuʻuanu"
      assert hurt.aid_stations.where.not(mile: 0).all?(&:drop_bag?),
             "runners may have personal supplies at any of the three aid stations"
      assert_not hurt.aid_stations.find_by!(mile: 47).pacer_access?,
                 "pacer pickup is not guaranteed before mile 60"
      assert hurt.aid_stations.find_by!(mile: 60).pacer_access?,
             "pacers may start at Makiki from mile 60"
      assert_not hurt.aid_stations.find_by!(mile: 92.5).pacer_access?,
                 "no pacers may start at Nuʻuanu even on the final lap"
      assert_equal "29h", hurt.aid_stations.find_by!(mile: 80).cutoff_elapsed_label
      assert_equal "33h 30m", hurt.aid_stations.find_by!(mile: 92.5).cutoff_elapsed_label
      assert_equal Time.find_zone("Pacific/Honolulu").parse("2027-01-17 6:00 PM"), hurt.final_cutoff_at
      assert_includes hurt.source_metadata.fetch("sources").pluck("url"),
                      "https://hurt100.com/book-of-hurt-2027/"

      long_haul = published_races.find { |published| published.slug == "long-haul-100" }
      assert_equal 2027, long_haul.year
      assert_equal Date.new(2027, 1, 16), long_haul.start_date
      assert long_haul.sold_out?, "the 2027 UltraSignup listing says the race is sold out"
      assert_equal false, long_haul.lottery
      assert_equal 32, long_haul.cutoff_hours
      assert_nil long_haul.elevation_gain_ft, "the organizer publishes no vert figure for the flat park"
      assert_equal 30, long_haul.aid_stations.count,
                   "a Start pass plus the per-loop South Loop x2, Metal Mark, HQ, and loops 2-6 Day Use passes"
      assert_equal 4, long_haul.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "four physical stations: HQ, South Loop, Metal Mark Pond, and Day Use"
      assert long_haul.aid_stations.all? { |station| station.has_medical == false },
             "the handbook states there are no medical checks before, during, or after the race"
      assert_equal 5, long_haul.aid_stations.count { |station| station.name.include?("Day Use") },
                   "the Day Use station is passed on loops 2-6 only"
      assert_not long_haul.aid_stations.find_by!(mile: 47).pacer_access?,
                 "pacers may not join before the end of loop 3"
      assert long_haul.aid_stations.find_by!(mile: 50.4).pacer_access?,
             "pacers join at the loop 3/4 HQ pass for loops 4-6"
      assert_equal 1, long_haul.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "no intermediate station cutoffs are published; only the 32-hour course cutoff"
      assert_equal "32h", long_haul.aid_stations.find_by!(mile: 100.8).cutoff_elapsed_label
      assert_equal Time.find_zone("America/New_York").parse("2027-01-17 3:00 PM"), long_haul.final_cutoff_at
      assert_includes long_haul.source_metadata.fetch("sources").pluck("url"),
                      "https://ultrasignup.com/register.aspx?did=134998"

      coldwater = published_races.find { |published| published.slug == "coldwater-rumble-100" }
      assert_equal 2027, coldwater.year
      assert_equal Date.new(2027, 1, 16), coldwater.start_date
      assert coldwater.open?, "registration is open until January 11, 2027"
      assert_equal false, coldwater.lottery
      assert_equal 32, coldwater.cutoff_hours
      assert_equal 8_687, coldwater.elevation_gain_ft, "the race page publishes total gain for the 100 Mile"
      assert_nil coldwater.elevation_loss_ft, "the organizer publishes gain only"
      assert_equal 17, coldwater.aid_stations.count,
                   "a Start pass, two Red Loops with Gila and HQ, and three Blue Loops with four passes each"
      assert_equal 5, coldwater.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "five physical stations: Rumble HQ, Gila, Rainbow Valley, Pedersen, Horse Thief"
      assert coldwater.aid_stations.where(name: [ "Start — Rumble HQ", "Rumble HQ", "Finish — Rumble HQ" ]).all?(&:has_medical?),
             "the HQ site layout marks a medical tent"
      assert_not coldwater.aid_stations.find_by!(mile: 39.3).pacer_access?,
                 "pacers may not join before mile 47.1 even at Horse Thief"
      assert coldwater.aid_stations.find_by!(mile: 47.1).pacer_access?,
             "pacing begins at Rumble HQ after mile 47.1"
      assert_not coldwater.aid_stations.find_by!(mile: 82.7).pacer_access?,
                 "pacers may not enter or exit at Rainbow Valley"
      assert_equal 6, coldwater.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "three hard cutoffs, two soft cutoffs, and the final cutoff"
      assert_equal "6h 30m", coldwater.aid_stations.find_by!(mile: 20.1).cutoff_elapsed_label
      assert_equal "29h 30m", coldwater.aid_stations.find_by!(mile: 93.3).cutoff_elapsed_label
      assert_equal Time.find_zone("America/Phoenix").parse("2027-01-17 3:00 PM"), coldwater.final_cutoff_at
      assert_includes coldwater.source_metadata.fetch("sources").pluck("url"),
                      "https://www.aravaiparunning.com/avr/wp-content/uploads/CWR26-Runner-Guide.pdf"

      shippey = published_races.find { |published| published.slug == "shippey-100" }
      assert_equal 2027, shippey.year
      assert_equal Date.new(2027, 1, 16), shippey.start_date
      assert shippey.open?
      assert_equal 34, shippey.cutoff_hours
      assert_nil shippey.elevation_gain_ft, "the organizer publishes no vert figure"
      assert_equal 26, shippey.aid_stations.count,
                   "a Start pass plus five passes on each of the five 20-mile loops"
      assert_equal 2, shippey.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "two indoor stations: Emerson and Sverdrup Lodge"
      assert_equal 15, shippey.aid_stations.count { |station| station.name.include?("Sverdrup") },
                   "Sverdrup is passed three times on each of the five loops"
      assert_not shippey.aid_stations.find_by!(mile: 36.4).pacer_access?,
                 "pacers may not join before 40 miles"
      assert shippey.aid_stations.find_by!(mile: 40).pacer_access?,
             "pacing begins after 40 miles (two loops) or 5:00 PM Saturday"
      assert_equal "32h", shippey.aid_stations.find_by!(mile: 93.2).cutoff_elapsed_label,
                   "the Sverdrup station shuts at 2:00 PM Sunday"
      assert_equal "34h", shippey.aid_stations.find_by!(mile: 100).cutoff_elapsed_label
      assert_equal Time.find_zone("America/Chicago").parse("2027-01-17 4:00 PM"), shippey.final_cutoff_at
      assert_includes shippey.source_metadata.fetch("sources").pluck("url"),
                      "https://ultrasignup.com/register.aspx?did=135549"

      forgotten = published_races.find { |published| published.slug == "forgotten-florida-100" }
      assert_equal 2027, forgotten.year
      assert_equal Date.new(2027, 1, 30), forgotten.start_date
      assert forgotten.open?
      assert_equal 34, forgotten.cutoff_hours
      assert_equal 24, forgotten.aid_stations.count, "the handbook matrix's 23 passes plus the start"
      assert_equal 14, forgotten.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "a point-to-point course over fourteen physical station locations"
      assert_not_equal forgotten.start_lat, forgotten.finish_lat,
                       "the course runs point to point from Oviedo to Tosohatchee"
      assert_equal 19, forgotten.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "the matrix publishes leave-by cutoffs at nineteen passes"
      assert_equal "Turnaround", forgotten.aid_stations.find_by!(mile: 52.6).direction,
                   "the 50-mile finish line is the 100-mile turnaround"
      assert_equal Time.find_zone("America/New_York").parse("2027-01-30 10:30 PM"), forgotten.turnaround_cutoff_at
      assert_not forgotten.aid_stations.find_by!(mile: 53.1).pacer_access?,
                 "the matrix marks no pacer pickup at False Finish"
      assert forgotten.aid_stations.find_by!(mile: 52.6).pacer_access?,
             "pacers join from the 50-mile turnaround onward"
      assert_equal 4, forgotten.aid_stations.count(&:drop_bag?),
                   "drop bags go to Joshua Creek and the three Charlie Lake passes"
      assert_equal "34h", forgotten.aid_stations.find_by!(mile: 98.85).cutoff_elapsed_label
      assert_equal Time.find_zone("America/New_York").parse("2027-01-31 4:30 PM"), forgotten.final_cutoff_at
      assert_includes forgotten.source_metadata.fetch("sources").pluck("url"),
                      "https://ultrasignup.com/register.aspx?did=135495"

      rocky = published_races.find { |published| published.slug == "rocky-raccoon-100" }
      assert_equal 2027, rocky.year
      assert_equal Date.new(2027, 2, 6), rocky.start_date
      assert rocky.open?
      assert_equal 32, rocky.cutoff_hours
      assert_equal 6_250, rocky.elevation_gain_ft, "five times the organizer's ~1,250 ft per-lap figure"
      assert_equal 21, rocky.aid_stations.count,
                   "a Start pass plus four chart passes on each of the five 20-mile laps"
      assert_equal 4, rocky.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "four physical stations: Tyler's, Gate, Nature Center, Dam Nation"
      assert rocky.aid_stations.all?(&:crew_accessible?), "the aid chart marks crew Y at every pass"
      assert_equal 10, rocky.aid_stations.count(&:drop_bag?),
                   "drop bags are delivered to Gate and Dam Nation on every lap"
      assert_not rocky.aid_stations.find_by!(mile: 43.8).pacer_access?,
                 "pacers may not join before mile 49"
      assert rocky.aid_stations.find_by!(mile: 49.1).pacer_access?,
             "pacing begins after mile 49"
      assert_equal 5, rocky.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "rolling cutoffs cover the final lap from mile 80"
      assert_equal "25h 36m", rocky.aid_stations.find_by!(mile: 80).cutoff_elapsed_label
      assert_equal "32h", rocky.aid_stations.find_by!(mile: 100).cutoff_elapsed_label
      assert_equal Time.find_zone("America/Chicago").parse("2027-02-07 2:00 PM"), rocky.final_cutoff_at
      assert_includes rocky.source_metadata.fetch("sources").pluck("url"),
                      "https://www.tejastrails.com/rocky100/"

      jackpot = published_races.find { |published| published.slug == "jackpot-100" }
      assert_equal 2027, jackpot.year
      assert_equal Date.new(2027, 2, 20), jackpot.start_date
      assert jackpot.open?
      assert_equal 30, jackpot.cutoff_hours
      assert_equal 45, jackpot.aid_stations.count,
                   "a Start pass, the short opening loop, and 43 certified-loop passes ending at 100.49"
      assert_equal 1, jackpot.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "every loop crosses the single Main Strip Aid Station"
      assert jackpot.aid_stations.all?(&:crew_accessible?), "crew sees their runner every lap"
      assert jackpot.aid_stations.all? { |station| station.has_medical == true },
             "first aid kits, an EMT, and a medical tent are onsite at the venue every loop crosses"
      assert jackpot.aid_stations.none?(&:pacer_access?),
             "the sunset-to-sunrise pacer allowance is time-based, so no pass guarantees pickup"
      assert_equal 1, jackpot.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "only the overall 30-hour cutoff is published"
      assert_equal "30h", jackpot.aid_stations.find_by!(mile: 100.49).cutoff_elapsed_label
      assert_equal [ 0.0, 1.18, 3.49 ], jackpot.aid_stations.order(:sequence).limit(3).pluck(:mile).map(&:to_f),
                   "the race opens with the short loop, then steps by the certified 2.3094 miles"
      assert_equal Time.find_zone("America/Los_Angeles").parse("2027-02-21 2:00 PM"), jackpot.final_cutoff_at
      assert_includes jackpot.source_metadata.fetch("sources").pluck("url"),
                      "https://www.aravaiparunning.com/avr/wp-content/uploads/2023/03/NV23003MWC-Jackpot-Ultras-Long-Course.pdf"

      orcas = published_races.find { |published| published.slug == "orcas-island-100" }
      assert_equal 2027, orcas.year
      assert_equal Date.new(2027, 2, 26), orcas.start_date
      assert orcas.open?
      assert_equal 36, orcas.cutoff_hours
      assert_equal 26_000, orcas.elevation_gain_ft, "the organizer publishes ~26,000 ft of gain"
      assert_equal 17, orcas.aid_stations.count,
                   "a Start pass plus four passes on each of the four nominal 25-mile loops"
      assert_equal 4, orcas.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "the organizer GPX's four station waypoints"
      assert_not orcas.aid_stations.find_by!(mile: 5).crew_accessible?,
                 "no crew at Mountain Lake on lap 1"
      assert orcas.aid_stations.find_by!(mile: 30).crew_accessible?,
             "crews are allowed at Mountain Lake from lap 2"
      assert_not orcas.aid_stations.find_by!(mile: 70).crew_accessible?,
                 "Mt Constitution allows crews on lap 4 only"
      assert_not orcas.aid_stations.find_by!(mile: 20).pacer_access?,
                 "no pacers on the first lap"
      assert orcas.aid_stations.find_by!(mile: 25).pacer_access?,
             "pacers join from mile 25 at crew-accessible stations"
      assert_not orcas.aid_stations.find_by!(mile: 45).pacer_access?,
                 "pacers may start from Mt Constitution on the last lap only"
      assert_equal 5, orcas.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "last-lap cutoffs run from mile 75 through the finish"
      assert_equal "27h", orcas.aid_stations.find_by!(mile: 75).cutoff_elapsed_label
      assert_equal "36h", orcas.aid_stations.find_by!(mile: 100).cutoff_elapsed_label
      assert_equal Time.find_zone("America/Los_Angeles").parse("2027-02-27 8:00 PM"), orcas.final_cutoff_at
      assert_includes orcas.source_metadata.fetch("sources").pluck("url"),
                      "https://www.rainshadowrunning.com/orcas100.html"

      lovit = published_races.find { |published| published.slug == "lovit-100" }
      assert_equal 2027, lovit.year
      assert_equal Date.new(2027, 2, 27), lovit.start_date
      assert lovit.open?
      assert_equal 34, lovit.cutoff_hours
      assert_nil lovit.elevation_gain_ft, "the organizer publishes no gain figure"
      assert_equal 23, lovit.aid_stations.count, "the aid chart's 23 rows"
      assert_equal 12, lovit.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "twelve physical station locations across the two out-and-backs"
      assert_equal 2, lovit.aid_stations.where(direction: "Turnaround").count,
                   "the Avery east end and ADA west end turnarounds"
      assert_equal Time.find_zone("America/Chicago").parse("2027-02-27 5:35 PM"), lovit.turnaround_cutoff_at,
                   "the first turnaround carries the Avery cutoff"
      assert_equal 6, lovit.aid_stations.count(&:pacer_access?),
                   "safety runners are picked up only at the six listed stations"
      assert_not lovit.aid_stations.find_by!(mile: 27.1).pacer_access?,
                 "eastbound Brady Mountain Road is not a pickup; westbound at 39.8 is"
      assert lovit.aid_stations.find_by!(mile: 39.8).pacer_access?
      assert_equal 6, lovit.aid_stations.count(&:drop_bag?),
                   "bags at Crystal Springs x2, Avery, Tompkin's x2, and the finish"
      assert_equal 4, lovit.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? }
      assert_equal "11h 35m", lovit.aid_stations.find_by!(mile: 32.8).cutoff_elapsed_label
      assert_equal "34h", lovit.aid_stations.find_by!(mile: 100).cutoff_elapsed_label
      assert_equal Time.find_zone("America/Chicago").parse("2027-02-28 4:00 PM"), lovit.final_cutoff_at
      assert_includes lovit.source_metadata.fetch("sources").pluck("url"),
                      "https://www.runlovit.com/s/lovit-100m-2025-jzzs.gpx"

      drift = published_races.find { |published| published.slug == "the-drift-100" }
      assert_equal 2027, drift.year
      assert_equal Date.new(2027, 3, 12), drift.start_date
      assert drift.not_open?, "UltraSignup registration opens October 1, 2026"
      assert_equal 55, drift.cutoff_hours
      assert_equal 101, drift.distance_mi, "the aid table's cumulative frame; the blurb bills 103"
      assert_equal 6, drift.aid_stations.count, "the aid table's six rows"
      assert_equal 5, drift.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "Strawberry is passed at 24.9 and again at 83.5"
      assert drift.aid_stations.none?(&:crew_accessible?),
             "the FAQ bans all outside assistance"
      assert drift.aid_stations.none?(&:pacer_access?), "no pacers in this human-powered race"
      assert drift.aid_stations.none? { |station| station.drop_bag == true },
             "no drop bags or gear drops anywhere"
      assert_equal 5, drift.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "leave-by cutoffs at every pass after the start"
      assert_equal "35h", drift.aid_stations.find_by!(mile: 67.3).cutoff_elapsed_label,
                   "clock-derived elapsed governs over the table's printed 33 hours"
      assert_equal "42h", drift.aid_stations.find_by!(mile: 83.5).cutoff_elapsed_label,
                   "true elapsed across the March 14 spring-forward"
      assert_equal Time.find_zone("America/Denver").parse("2027-03-14 5:00 PM"), drift.final_cutoff_at,
                   "9:00 AM Friday plus 55 hours lands at 5:00 PM Sunday across the DST change"
      assert_includes drift.source_metadata.fetch("sources").pluck("url"),
                      "https://www.thedrift100.com/100-mile-course/"

      viper = published_races.find { |published| published.slug == "viper-100" }
      assert_equal 2027, viper.year
      assert_equal Date.new(2027, 3, 19), viper.start_date
      assert viper.open?
      assert_equal 41, viper.cutoff_hours
      assert_equal 100.2, viper.distance_mi.to_f, "three 33.4-mile loops"
      assert_equal 19, viper.aid_stations.count,
                   "a Start pass plus six passes on each of three loops"
      assert_equal 4, viper.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "four physical stations: Hyde Lake, Bridge, Refuge, and Tour de Wolf"
      assert_equal 6, viper.aid_stations.where(crew_accessible: false).count,
                   "no crew at any Bridge pass"
      assert_equal 8, viper.aid_stations.count(&:pacer_access?),
                   "pacers join at crew-accessible stations after one full loop"
      assert_not viper.aid_stations.find_by!(mile: 10.8).pacer_access?,
                 "no pacers on loop one"
      assert_not viper.aid_stations.find_by!(mile: 100.2).pacer_access?,
                 "no pickup at the finish"
      assert_equal 9, viper.aid_stations.count(&:drop_bag?),
                   "bags at every Tour de Wolf and Hyde Lake pass"
      assert_equal 6, viper.aid_stations.where(has_medical: true).count,
                   "medical support is published at Tour de Wolf"
      assert_equal 1, viper.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "only the 41-hour finish cutoff is published"
      assert_equal Time.find_zone("America/Chicago").parse("2027-03-21 12:00 AM"), viper.final_cutoff_at,
                   "7:00 AM Friday plus 41 hours is midnight entering Sunday"
      assert_includes viper.source_metadata.fetch("sources").pluck("url"),
                      "https://ultrasignup.com/register.aspx?did=137755"

      pistol = published_races.find { |published| published.slug == "pistol-ultra-100" }
      assert_equal 2027, pistol.year
      assert_equal Date.new(2027, 3, 13), pistol.start_date
      assert pistol.open?
      assert_equal 32, pistol.cutoff_hours
      assert_equal 100, pistol.distance_mi, "ten 10-mile Imperial loops"
      assert_equal 51, pistol.aid_stations.count,
                   "a Start pass plus five passes on each of ten loops"
      assert_equal 3, pistol.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "three physical stations: Long Run Store, Woody's, and Lucky's"
      assert_equal 11, pistol.aid_stations.where(crew_accessible: true).count,
                   "crew only at the Springbrook start/finish hub"
      assert pistol.aid_stations.all?(&:pacer_access?),
             "foot pacing is permitted from the start"
      assert pistol.aid_stations.all? { |station| station.drop_bag.nil? },
             "no drop-bag service is published; runners self-support from the canopy area"
      assert_equal 1, pistol.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "only the 32-hour finish cutoff is published"
      assert_equal "32h", pistol.aid_stations.find_by!(mile: 100).cutoff_elapsed_label
      assert_equal Time.find_zone("America/New_York").parse("2027-03-14 5:00 PM"), pistol.final_cutoff_at,
                   "8:00 AM EST Saturday plus 32 hours is 5:00 PM EDT Sunday across the DST change"
      assert_includes pistol.source_metadata.fetch("sources").pluck("url"),
                      "https://www.pistolultra.com/Race/ThePistolCreekRun/Page/Course-Route"

      warbird = published_races.find { |published| published.slug == "warbird-100" }
      assert_equal 2027, warbird.year
      assert_equal Date.new(2027, 3, 19), warbird.start_date
      assert warbird.open?
      assert_equal 35, warbird.cutoff_hours
      assert_equal 102.2, warbird.distance_mi.to_f, "the aid table's cumulative frame"
      assert_equal 15_676, warbird.elevation_gain_ft, "the race info PDF's CalTopo profile"
      assert_equal 17, warbird.aid_stations.count, "the Start plus the aid table's sixteen rows"
      assert_equal 16, warbird.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "one big loop; only the start/finish repeats"
      assert_equal 5, warbird.aid_stations.where(crew_accessible: true).count,
                   "Bear Creek, Peabody, Sugar Creek, and the start/finish hub"
      assert_equal 4, warbird.aid_stations.count(&:pacer_access?),
                   "pacers join at Bowens Creek and trade at the three crewed stations"
      assert warbird.aid_stations.find_by!(mile: 32.6).pacer_access?,
             "Bowens Creek is a pacer drop-off despite having no crew access"
      assert_not warbird.aid_stations.find_by!(mile: 32.6).crew_accessible?
      assert_equal 9, warbird.aid_stations.count(&:drop_bag?), "the drop-bag list's nine stations"
      assert_equal 15, warbird.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "leave-by clocks at every station after Coke Syrup"
      assert_equal "27h 30m", warbird.aid_stations.find_by!(mile: 80.9).cutoff_elapsed_label,
                   "Sugar Creek's misprinted 10:30 PM is recorded as 10:30 AM"
      assert_equal Time.find_zone("America/New_York").parse("2027-03-20 6:00 PM"), warbird.final_cutoff_at,
                   "7:00 AM Friday plus 35 hours, no DST crossing after March 14"
      assert_includes warbird.source_metadata.fetch("sources").pluck("url"),
                      "https://www.trailsick.com/s/Warbird-100-Aid-Station-Details.pdf"

      bootlegger = published_races.find { |published| published.slug == "bootlegger-100" }
      assert_equal 2027, bootlegger.year
      assert_equal Date.new(2027, 3, 20), bootlegger.start_date
      assert bootlegger.open?
      assert_equal 35, bootlegger.cutoff_hours, "run100s' 32 is stale; the site says 35"
      assert_equal 100, bootlegger.distance_mi, "eight 12.5-mile loops"
      assert_nil bootlegger.elevation_gain_ft, "the organizer's own gain figures conflict"
      assert_equal 17, bootlegger.aid_stations.count,
                   "a Start pass plus two passes on each of eight loops"
      assert_equal 2, bootlegger.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "two physical stations: the Group Shelter hub and Aid Station 2"
      assert_equal 9, bootlegger.aid_stations.where(crew_accessible: true).count,
                   "crew only at the Group Shelter start/finish"
      assert_equal 7, bootlegger.aid_stations.count(&:pacer_access?),
                   "pacers join at the hub after 5:00 PM, not at the Start or Finish"
      assert_equal 8, bootlegger.aid_stations.count(&:drop_bag?),
                   "drop bags serve the mile-6.2 station only"
      assert_equal 2, bootlegger.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "the noon last-loop gate and the 35-hour finish"
      assert_equal "30h", bootlegger.aid_stations.find_by!(mile: 87.5).cutoff_elapsed_label,
                   "the last loop must start by noon Sunday"
      assert_equal Time.find_zone("America/New_York").parse("2027-03-21 5:00 PM"), bootlegger.final_cutoff_at,
                   "6:00 AM Saturday plus 35 hours, no DST crossing after March 14"
      assert_includes bootlegger.source_metadata.fetch("sources").pluck("url"),
                      "https://www.bootlegger100.com/"

      badger = published_races.find { |published| published.slug == "badger-mountain-100" }
      assert_equal 2027, badger.year
      assert_equal Date.new(2027, 3, 26), badger.start_date
      assert badger.not_open?, "UltraSignup registration opens November 30, 2026"
      assert_equal 32.5, badger.cutoff_hours.to_f, "the course closes at 3:30 PM Saturday"
      assert_equal 18_431, badger.elevation_gain_ft
      assert_equal 25, badger.aid_stations.count,
                   "the chart's thirteen rows per 50-mile trip, done twice"
      assert_equal 8, badger.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "seven stations plus separate outbound and inbound ridge markers"
      assert_equal 2, badger.aid_stations.where(direction: "Turnaround").count,
                   "Chandler Butte on each trip"
      assert_equal 4, badger.aid_stations.where(has_water: false).count,
                   "the directional-only McBee Ridge markers carry no aid"
      assert_equal 5, badger.aid_stations.count(&:pacer_access?),
                   "pacers join at the 50-mile turnaround or crew stations after it"
      assert_not badger.aid_stations.find_by!(mile: 45.4).pacer_access?,
                 "Candy Mtn is a pacer point only after 50 miles"
      assert_equal 6, badger.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? },
                   "the chart's six cutoff clocks"
      assert_equal "15h", badger.aid_stations.find_by!(mile: 50).cutoff_elapsed_label,
                   "the 50-mile turnaround closes at 10:00 PM Friday"
      assert_equal Time.find_zone("America/Los_Angeles").parse("2027-03-27 3:30 PM"), badger.final_cutoff_at,
                   "7:00 AM Friday plus 32.5 hours"
      assert_includes badger.source_metadata.fetch("sources").pluck("url"),
                      "https://docs.google.com/spreadsheets/d/1aHQPNF9a4MOfIDb6mwB_3mLBb10kPbOP/edit"

      crown = published_races.find { |published| published.slug == "crown-stub-100" }
      assert_equal 2027, crown.year
      assert_equal Date.new(2027, 4, 24), crown.start_date
      assert crown.open?
      assert_equal 32, crown.cutoff_hours, "run100s' 30 is stale; the aid page says 32"
      assert_equal 100.2, crown.distance_mi.to_f, "the aid chart's cumulative frame"
      assert_equal 7000, crown.elevation_gain_ft
      assert_equal 17, crown.aid_stations.count,
                   "the Start, thirteen aid stops, two turnarounds, and the Finish"
      assert_equal 9, crown.aid_stations.map { |station| [ station.lat, station.lng ] }.uniq.size,
                   "seven stations plus the two turnaround markers"
      assert_equal 2, crown.aid_stations.where(direction: "Turnaround").count,
                   "Hwy 30 and Banks"
      assert_equal 16.0, crown.aid_stations.where("name LIKE 'Vernonia%'").minimum(:mile).to_f,
                   "the chart's printed 18 is corrected by its own segment chain"
      assert_equal 1, crown.aid_stations.count(&:pacer_access?),
                   "Pisgah mile 40.2 is the only published pacer join point"
      assert_equal 6, crown.aid_stations.count(&:drop_bag?),
                   "two bags, six accesses: Stewarts Gate four times and Vernonia twice"
      assert_equal 13, crown.aid_stations.where(has_medical: true).count,
                   "official stations carry medical support"
      assert_equal 2, crown.aid_stations.count { |station| station.cutoff_elapsed_minutes.present? }
      assert_equal "26h", crown.aid_stations.find_by!(mile: 71.7).cutoff_elapsed_label,
                   "Stewarts Gate closes at 2:00 PM Sunday from the noon start"
      assert_equal Time.find_zone("America/Los_Angeles").parse("2027-04-25 8:00 PM"), crown.final_cutoff_at,
                   "noon Saturday plus 32 hours"
      assert_includes crown.source_metadata.fetch("sources").pluck("url"),
                      "https://caltopo.com/m/BEDR0FU"
    end

    test "replaces stale Bighorn rows when publishing the Active event catalog" do
      stale_race = Race.create!(
        name: "Bighorn 100",
        slug: "bighorn-100",
        year: 2026,
        source_metadata: { "verified_on" => "2026-07-02" }
      )
      stale_race.aid_stations.create!(
        name: "Dry Fork Ridge",
        sequence: 1,
        mile: 13.5,
        has_water: true,
        source_metadata: { "verified_on" => "2026-07-02" }
      )

      published_race = Import.new(Rails.root.join("db/events/active.yml")).call.find { |race| race.slug == "bighorn-100" }

      assert_not_equal stale_race.id, published_race.id
      assert_equal "2026-08-13", published_race.source_metadata.dig("section_verifications", "station_passes", "verified_on")
      assert_nil published_race.aid_stations.find_by!(mile: 13.5).has_water
      assert_nil published_race.aid_stations.find_by!(mile: 0).drop_bag
    end

    test "publishes every Race in the explicit Active event catalog" do
      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "first-hundred", name: "First Hundred")
        write_bundle(directory, slug: "second-hundred", name: "Second Hundred")
        write_catalog(catalog_path, %w[first-hundred.bundle.yml second-hundred.bundle.yml])

        published_races = Import.new(catalog_path).call

        assert_equal [ "First Hundred", "Second Hundred" ], published_races.map(&:name)
        assert_equal [ "first-hundred", "second-hundred" ], Race.order(:slug).pluck(:slug)
        assert published_races.all? { |race| race.aid_stations.one? }
      end
    end

    test "leaves the published Races unchanged when a required bundle file is missing" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "first-hundred", name: "First Hundred")
        write_bundle(directory, slug: "broken-hundred", name: "Broken Hundred")
        write_catalog(catalog_path, %w[first-hundred.bundle.yml broken-hundred.bundle.yml])
        File.delete(File.join(directory, "broken-hundred.gpx"))

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "broken-hundred.gpx is missing", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects an owned artifact whose declared SHA-256 digest does not match" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "changed-hundred", name: "Changed Hundred")
        write_catalog(catalog_path, %w[changed-hundred.bundle.yml])
        File.write(File.join(directory, "terrain/changed-hundred.json"), JSON.generate("version" => 2))

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "changed-hundred.json SHA-256 does not match", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects a stale Terrain artifact reference before replacing the published Races" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "stale-hundred", name: "Stale Hundred")
        write_catalog(catalog_path, %w[stale-hundred.bundle.yml])
        race_path = File.join(directory, "stale-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("race").fetch("terrain_artifacts")["sha256"] = "0" * 64
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "stale-hundred", "race")

        error = assert_raises(Terrain::Artifact::Invalid) { Import.new(catalog_path).call }

        assert_match(/SHA-256/i, error.message)
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects an Event bundle when a Station pass has no matching course waypoint" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "unmatched-hundred", name: "Unmatched Hundred")
        write_catalog(catalog_path, %w[unmatched-hundred.bundle.yml])
        race_path = File.join(directory, "unmatched-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("aid_stations").first["match"] = "Not in the course"
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "unmatched-hundred", "race")

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "Station pass Start has no course waypoint matching", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "requires a generated Terrain artifact to be declared by its Event bundle" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "unowned-hundred", name: "Unowned Hundred")
        write_catalog(catalog_path, %w[unowned-hundred.bundle.yml])
        manifest_path = File.join(directory, "unowned-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest.fetch("files").delete("terrain")
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "generated Terrain artifact is not declared", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "requires the declared Terrain artifact to match the runtime path" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "misdirected-hundred", name: "Misdirected Hundred")
        write_catalog(catalog_path, %w[misdirected-hundred.bundle.yml])
        race_path = File.join(directory, "misdirected-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("race").fetch("terrain_artifacts")["path"] = "/terrain/different.json"
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "misdirected-hundred", "race")

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "declared Terrain artifact does not match its runtime path", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "requires a generated crew route to be declared by its Event bundle" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "unrouted-hundred", name: "Unrouted Hundred")
        write_catalog(catalog_path, %w[unrouted-hundred.bundle.yml])
        manifest_path = File.join(directory, "unrouted-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest.fetch("files").delete("crew_route")
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "generated crew route is not declared", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects a bundle whose manifest and Race record name different slugs" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "identity-hundred", name: "Identity Hundred")
        write_catalog(catalog_path, %w[identity-hundred.bundle.yml])
        manifest_path = File.join(directory, "identity-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest["slug"] = "another-hundred"
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "manifest slug another-hundred does not match Race slug identity-hundred", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects duplicate Races in the Active event catalog before publication" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "duplicate-hundred", name: "Duplicate Hundred")
        write_catalog(catalog_path, %w[duplicate-hundred.bundle.yml duplicate-hundred.bundle.yml])

        error = assert_raises(Import::InvalidCatalog) { Import.new(catalog_path).call }

        assert_match "duplicate Race slug duplicate-hundred", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects an unsupported Event bundle manifest version" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "future-hundred", name: "Future Hundred")
        write_catalog(catalog_path, %w[future-hundred.bundle.yml])
        manifest_path = File.join(directory, "future-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest["version"] = 2
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "unsupported Event bundle version 2", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "removes Races absent from the Active event catalog" do
      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "remaining-hundred", name: "Remaining Hundred")
        write_bundle(directory, slug: "retired-hundred", name: "Retired Hundred")
        write_catalog(catalog_path, %w[remaining-hundred.bundle.yml retired-hundred.bundle.yml])
        Import.new(catalog_path).call
        write_catalog(catalog_path, %w[remaining-hundred.bundle.yml])

        published_races = Import.new(catalog_path).call

        assert_equal [ "remaining-hundred" ], published_races.map(&:slug)
        assert_equal [ "remaining-hundred" ], Race.pluck(:slug)
      end
    end

    test "replaces a Race projection without retaining facts removed from its Event bundle" do
      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "changing-hundred", name: "Changing Hundred")
        write_catalog(catalog_path, %w[changing-hundred.bundle.yml])
        race_path = File.join(directory, "changing-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("race")["official_url"] = "https://example.com/old"
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "changing-hundred", "race")
        Import.new(catalog_path).call
        data.fetch("race").delete("official_url")
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "changing-hundred", "race")

        published_race = Import.new(catalog_path).call.first

        assert_nil published_race.official_url
        assert_equal 1, Race.where(slug: "changing-hundred").count
      end
    end

    test "validates every Race projection before publication writes begin" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "valid-hundred", name: "Valid Hundred")
        write_bundle(directory, slug: "invalid-hundred", name: "Invalid Hundred")
        write_catalog(catalog_path, %w[valid-hundred.bundle.yml invalid-hundred.bundle.yml])
        race_path = File.join(directory, "invalid-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("race").delete("name")
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "invalid-hundred", "race")

        assert_raises(ActiveRecord::RecordInvalid) { Import.new(catalog_path).call }

        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    private

    def with_event_catalog
      Dir.mktmpdir("event-catalog") do |directory|
        yield File.join(directory, "active.yml"), directory
      end
    end

    def write_catalog(path, manifests)
      File.write(path, { "active_event_bundles" => manifests }.to_yaml)
    end

    def write_bundle(directory, slug:, name:)
      files = {
        "race" => "#{slug}.yml",
        "course" => "#{slug}.gpx",
        "crew_route" => "#{slug}.crew_route.json",
        "terrain" => "terrain/#{slug}.json"
      }

      terrain = Terrain::Artifact.write(
        terrain_payload(slug: slug, name: name),
        to: File.join(directory, files.fetch("terrain"))
      )
      File.write(File.join(directory, files.fetch("race")), {
        "race" => {
          "name" => name,
          "slug" => slug,
          "year" => 2026,
          "terrain_artifacts" => terrain.reference(path: "/terrain/#{slug}.json")
        },
        "elevation_series" => [],
        "crew_drive_order" => [ "Start" ],
        "aid_stations" => [ {
          "match" => "Start",
          "name" => "Start",
          "mile" => 0,
          "elev" => 5_000,
          "crew" => true,
          "pacer" => false,
          "drop" => false,
          "food" => true,
          "med" => false
        } ]
      }.to_yaml)
      File.write(File.join(directory, files.fetch("course")), <<~GPX)
        <gpx>
          <wpt lat="44.0" lon="-107.0"><name>Start</name></wpt>
          <trk><trkseg>
            <trkpt lat="44.0" lon="-107.0" />
            <trkpt lat="45.0" lon="-108.0" />
          </trkseg></trk>
        </gpx>
      GPX
      File.write(File.join(directory, files.fetch("crew_route")), JSON.generate("legs" => []))

      manifest = {
        "version" => 1,
        "slug" => slug,
        "files" => files.transform_values do |file|
          path = File.join(directory, file)
          { "path" => file, "sha256" => Digest::SHA256.file(path).hexdigest }
        end
      }
      File.write(File.join(directory, "#{slug}.bundle.yml"), manifest.to_yaml)
    end

    def terrain_payload(slug:, name:)
      {
        "race" => { "slug" => slug, "name" => name, "year" => 2026 },
        "generated_at" => "2026-08-12T12:00:00Z",
        "source" => {
          "label" => "Terrain source",
          "url" => "https://example.test/terrain",
          "attribution" => "Example terrain data"
        },
        "grid" => {
          "size" => 2,
          "zoom" => 11,
          "bounds" => { "min_lat" => 44.0, "max_lat" => 45.0, "min_lng" => -108.0, "max_lng" => -107.0 },
          "min_ft" => 4_000,
          "max_ft" => 4_300,
          "elevations_ft" => [ 4_000, 4_100, 4_200, 4_300 ]
        },
        "course_grade_profile" => { "segments" => [] }
      }
    end

    def refresh_digest(directory, slug, role)
      manifest_path = File.join(directory, "#{slug}.bundle.yml")
      manifest = YAML.load_file(manifest_path)
      declaration = manifest.fetch("files").fetch(role)
      declaration["sha256"] = Digest::SHA256.file(File.join(directory, declaration.fetch("path"))).hexdigest
      File.write(manifest_path, manifest.to_yaml)
    end
  end
end
