module StationPassPresentation
  LANDMARK_DIRECTIONS = %w[Start Turnaround Finish].freeze

  module_function

  def call(station_pass, next_station_pass: nil)
    features = features(station_pass)
    directions = directions(station_pass)
    verification = verification(station_pass)
    next_station_pass = next_station_pass_presentation(station_pass, next_station_pass)
    presentation = {
      id: station_pass.id,
      details_id: ActionView::RecordIdentifier.dom_id(station_pass, :station_pass),
      name: station_pass.name,
      sequence: station_pass.sequence,
      mile: station_pass.mile&.to_f,
      direction: station_pass.direction,
      direction_label: station_pass.direction.presence || "Pass",
      cutoff: station_pass.cutoff,
      cutoff_clock: station_pass.cutoff_clock,
      cutoff_elapsed_minutes: station_pass.cutoff_elapsed_minutes,
      cutoff_elapsed_label: station_pass.cutoff_elapsed_label,
      cutoff_label: cutoff_label(station_pass),
      landmark: LANDMARK_DIRECTIONS.include?(station_pass.direction),
      elevation_ft: station_pass.elevation_ft,
      elevation: station_pass.elevation_ft ? "#{ActiveSupport::NumberHelper.number_to_delimited(station_pass.elevation_ft)} ft" : "Not listed",
      features: features,
      filter_tags: features.filter_map { |feature| feature[:filter] if feature[:available] },
      crew: station_pass.crew_accessible,
      pacer_pickup: station_pass.pacer_access,
      drop_bag: station_pass.drop_bag,
      water: station_pass.has_water,
      water_label: availability_label(station_pass.has_water),
      potable_water: station_pass.potable_water,
      potable_water_label: availability_label(station_pass.potable_water),
      food: station_pass.has_food,
      medical: station_pass.has_medical,
      access_notes: station_pass.parking_notes.presence || station_pass.crew_access_notes.presence || "—",
      aid: station_pass.aid_notes.presence,
      bathroom: station_pass.bathroom_notes.presence,
      parking: station_pass.parking_notes.presence,
      crew_notes: station_pass.crew_access_notes,
      pacer_notes: station_pass.pacer_notes,
      directions_notes: station_pass.directions_notes,
      road_notes: station_pass.road_notes,
      road: station_pass.road_notes.presence,
      directions: directions,
      source_metadata: station_pass.source_metadata,
      verification: verification,
      next_station_pass: next_station_pass,
      lat: station_pass.lat&.to_f,
      lng: station_pass.lng&.to_f
    }
    presentation.merge(details: details(presentation))
  end

  def cutoff_label(station_pass)
    normalized = [ station_pass.cutoff_clock, station_pass.cutoff_elapsed_label ].compact_blank
    return normalized.join(" / ") if normalized.any?
    return station_pass.cutoff if station_pass.cutoff.present?

    "None listed"
  end
  private_class_method :cutoff_label

  def features(station_pass)
    [
      feature("crew", "Crew", station_pass.crew_accessible?, station_pass.crew_access_notes,
              filter: "crew", available_value: "Allowed", no_notes_label: "Crew allowed"),
      feature("drop_bag", "Drop bag", station_pass.drop_bag, filter: "drop"),
      feature("pacer", "Pacer pickup", station_pass.pacer_access?, station_pass.pacer_notes,
              filter: "pacer", available_value: "Allowed", no_notes_label: "Pacer pickup allowed"),
      feature("medical", "Medical", station_pass.has_medical)
    ]
  end
  private_class_method :features

  def feature(key, label, available, notes = nil, filter: nil, available_value: "Yes", no_notes_label: label)
    value = if available == true
      available_value
    elsif available == false
      "No"
    else
      "Not specified"
    end

    {
      key: key,
      label: label,
      available: available,
      value: value,
      detail_label: notes.present? ? label : no_notes_label,
      detail: notes.presence || value,
      filter: filter
    }
  end
  private_class_method :feature

  def details(presentation)
    features = presentation[:features].index_by { |feature| feature[:key] }
    directions = presentation[:directions]
    verification = presentation[:verification]

    rows = [
      detail("Elevation", presentation[:elevation]),
      detail("Cutoff", presentation[:cutoff_label]),
      detail("Aid", presentation[:aid] || "Not listed"),
      detail("Water listed", presentation[:water_label]),
      detail("Potable water", presentation[:potable_water_label]),
      detail("To next pass", presentation.dig(:next_station_pass, :label) || "Course complete"),
      detail(features.fetch("medical")[:detail_label], features.fetch("medical")[:detail]),
      detail("Bathrooms", presentation[:bathroom] || "Not listed"),
      detail(features.fetch("drop_bag")[:detail_label], features.fetch("drop_bag")[:detail]),
      detail(features.fetch("crew")[:detail_label], features.fetch("crew")[:detail]),
      detail(features.fetch("pacer")[:detail_label], features.fetch("pacer")[:detail]),
      detail("Parking", presentation[:parking] || "Not listed"),
      detail("Road", presentation[:road] || "Not listed"),
      detail("Directions", directions[:notes] || ("Not listed" if directions[:url].nil?), link: link(directions[:link_label], directions[:url])),
      detail("Verification", verification[:label]),
      *source_details(verification)
    ]
    rows << detail("Source notes", verification[:source_notes]) if verification[:source_notes]
    rows
  end
  private_class_method :details

  def source_details(verification)
    sources = verification[:sources]
    return sources.each_with_index.map do |source, index|
      detail("Source #{index + 1}", source[:url] ? nil : source[:label], link: link(source[:label], source[:url]))
    end if sources.any?

    [ detail("Source", verification[:source_url] ? nil : verification[:source_label],
             link: link(verification[:source_label], verification[:source_url])) ]
  end
  private_class_method :source_details

  def detail(label, value, link: nil)
    { label: label, value: value, link: link }.compact
  end
  private_class_method :detail

  def link(label, url)
    { label: label, url: url } if url
  end
  private_class_method :link

  def directions(station_pass)
    destination = if station_pass.coordinates?
      "#{format('%.6f', station_pass.lat.to_f)},#{format('%.6f', station_pass.lng.to_f)}"
    end

    {
      notes: station_pass.directions_notes.presence,
      link_label: station_pass.directions_notes.present? ? "Open map" : "Open directions",
      url: destination && "https://www.google.com/maps/dir/?api=1&destination=#{destination}"
    }
  end
  private_class_method :directions

  def verification(station_pass)
    metadata = station_pass.source_metadata || {}
    status = metadata["verification_status"].presence_in(%w[verified warning unverified]) || "unverified"
    sources = Array(metadata["sources"]).filter_map do |source|
      label = source["label"].presence
      next if label.nil?

      { label: label, url: source["url"].presence }
    end

    {
      status: status,
      label: { "verified" => "Verified source", "warning" => "Source warning" }.fetch(status, "Unverified"),
      verified_on: metadata["verified_on"].presence,
      source_label: metadata["source_label"].presence || metadata["source_url"].presence || "Not listed",
      source_url: metadata["source_url"].presence,
      source_notes: metadata["source_notes"].presence,
      sources: sources
    }
  end
  private_class_method :verification

  def availability_label(value)
    return "Yes" if value == true
    return "No" if value == false

    "Not specified"
  end
  private_class_method :availability_label

  def next_station_pass_presentation(station_pass, next_station_pass)
    return if next_station_pass.nil?

    distance = if station_pass.mile && next_station_pass.mile
      next_station_pass.mile.to_d - station_pass.mile.to_d
    end
    elevation_change = if station_pass.elevation_ft && next_station_pass.elevation_ft
      next_station_pass.elevation_ft - station_pass.elevation_ft
    end
    distance_label = if distance
      value = ActiveSupport::NumberHelper.number_to_rounded(distance, precision: 2, strip_insignificant_zeros: true)
      "#{value} mi"
    end
    elevation_label = if next_station_pass.elevation_ft
      "#{ActiveSupport::NumberHelper.number_to_delimited(next_station_pass.elevation_ft)} ft"
    else
      "Elevation not listed"
    end
    elevation_change_label = case elevation_change&.<=> 0
    when 1 then "Up #{ActiveSupport::NumberHelper.number_to_delimited(elevation_change)} ft net"
    when -1 then "Down #{ActiveSupport::NumberHelper.number_to_delimited(elevation_change.abs)} ft net"
    when 0 then "Level"
    end

    {
      name: next_station_pass.name,
      distance: distance_label || "Distance not listed",
      elevation: elevation_label,
      elevation_change: elevation_change_label,
      label: [ distance_label && "#{distance_label} by markers", elevation_label && "next marker #{elevation_label}",
               elevation_change_label && "#{elevation_change_label} between markers" ].compact.join(" · ")
    }
  end
  private_class_method :next_station_pass_presentation
end
