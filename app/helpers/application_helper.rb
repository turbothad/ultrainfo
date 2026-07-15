module ApplicationHelper
  # Compact marker for boolean columns in the aid-station tables.
  def yes_no(flag)
    if flag
      tag.span "Yes", class: "font-mono text-[11px] font-bold uppercase tracking-[0.08em] text-pine", title: "Yes"
    else
      tag.span "No", class: "font-mono text-[11px] uppercase tracking-[0.08em] text-stone-light", title: "No"
    end
  end

  def race_date_label(race)
    return "Date TBD" if race.start_date.blank?
    return race.start_date.strftime("%B %-d, %Y") if race.end_date.blank? || race.end_date == race.start_date

    if race.start_date.year != race.end_date.year
      "#{race.start_date.strftime('%B %-d, %Y')} - #{race.end_date.strftime('%B %-d, %Y')}"
    elsif race.start_date.month != race.end_date.month
      "#{race.start_date.strftime('%B %-d')} - #{race.end_date.strftime('%B %-d, %Y')}"
    else
      "#{race.start_date.strftime('%B %-d')} - #{race.end_date.strftime('%-d, %Y')}"
    end
  end

  def source_status_label(metadata)
    case metadata&.dig("verification_status")
    when "verified" then "Verified source"
    when "warning" then "Source warning"
    when "unverified" then "Unverified"
    else "Source pending"
    end
  end

  def latest_verified_on_label(metadata)
    verified_on_values = [ metadata&.dig("verified_on") ]
    verified_on_values.concat(Array(metadata&.dig("sources")).pluck("verified_on"))

    dates = verified_on_values.compact_blank.filter_map do |value|
      Date.iso8601(value.to_s)
    rescue Date::Error
      nil
    end

    dates.max&.strftime("%B %-d, %Y")
  end

  def registration_display(race)
    status = race.registration_status.humanize
    return status if race.registration_url.blank?

    link = link_to "Official registration", race.registration_url,
                   target: "_blank", rel: "noopener", class: "font-semibold text-pine no-underline hover:text-ink"
    safe_join [ status, link ], " · "
  end

  def cutoff_display(station)
    normalized = [ station.cutoff_clock, station.cutoff_elapsed_label ].compact_blank
    return normalized.join(" / ") if normalized.any?
    return station.cutoff if station.cutoff.present?

    "None listed"
  end

  def overall_cutoff_display(race)
    parts = []
    parts << "#{race.cutoff_hours.to_i}h" if race.cutoff_hours.present?
    parts << race.source_metadata["overall_cutoff_label"] if race.source_metadata["overall_cutoff_label"].present?
    parts.presence&.join(" / ") || "Not listed"
  end

  def key_race_times(race)
    [
      [ "Start", local_race_time(race.starts_at) ],
      [ "Turnaround cutoff", local_race_time(race.turnaround_cutoff_at) ],
      [ "Final cutoff", local_race_time(race.final_cutoff_at) ]
    ]
  end

  def directions_destination(station)
    return unless station.coordinates?

    "#{format('%.6f', station.lat.to_f)},#{format('%.6f', station.lng.to_f)}"
  end

  def aid_station_detail_rows(station)
    metadata = station.source_metadata || {}
    source = metadata["source_label"].presence || metadata["source_url"].presence || "Not listed"
    if metadata["source_url"].present?
      source = link_to source, metadata["source_url"], target: "_blank", rel: "noopener",
                       class: "font-semibold text-pine underline-offset-4 hover:text-ink"
    end

    directions = [ station.directions_notes.presence ].compact
    if (destination = directions_destination(station))
      label = directions.any? ? "Open map" : "Open directions"
      directions << link_to(label, "https://www.google.com/maps/dir/?api=1&destination=#{destination}", target: "_blank", rel: "noopener",
                            class: "font-semibold text-pine underline-offset-4 hover:text-ink")
    end

    rows = [
      [ "Elevation", station.elevation_ft ? "#{number_with_delimiter station.elevation_ft} ft" : "Not listed" ],
      [ "Cutoff", cutoff_display(station) ],
      [ "Aid", station.aid_notes.presence || "Not listed" ],
      [ "Medical", station.has_medical? ? "Yes" : "No" ],
      [ "Bathrooms", station.bathroom_notes.presence || "Not listed" ],
      [ "Drop bag", station.drop_bag? ? "Yes" : "No" ],
      [ "Crew", station.crew_access_notes.presence || (station.crew_accessible? ? "Yes" : "No") ],
      [ "Pacer", station.pacer_notes.presence || (station.pacer_access? ? "Yes" : "No") ],
      [ "Parking", station.parking_notes.presence || "Not listed" ],
      [ "Road", station.road_notes.presence || "Not listed" ],
      [ "Directions", directions.any? ? safe_join(directions, " · ") : "Not listed" ],
      [ "Verification", source_status_label(metadata) ],
      [ "Source", source ]
    ]
    rows << [ "Source notes", metadata["source_notes"] ] if metadata["source_notes"].present?
    rows
  end

  def aid_station_summary_stats(race)
    stations = race.aid_stations.to_a
    [
      [ "Station passes", stations.size ],
      [ "Drop bags", stations.count(&:drop_bag?) ],
      [ "Medical", stations.count(&:has_medical?) ],
      [ "Crew access", stations.count(&:crew_accessible?) ],
      [ "Pacer points", stations.count(&:pacer_access?) ],
      [ "Overall cutoff", race.cutoff_hours ? "#{race.cutoff_hours.to_i} hours" : nil ]
    ]
  end

  def crew_drive_summary(race)
    route = race.crew_route
    return if route.blank?

    summary = "Approx. #{route['distance_mi']} mi / #{(route['duration_min'] / 60.0).round(1)} h"
    return summary if race.source_metadata["crew_drive_label"].blank?

    "#{summary}. Route: #{race.source_metadata['crew_drive_label']}"
  end

  private

  def local_race_time(time)
    time&.strftime("%a · %-l:%M %p %Z") || "Not listed"
  end
end
