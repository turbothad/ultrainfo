require "digest"
require "time"

module Terrain
  class Artifact
    class Invalid < StandardError; end

    SCHEMA_VERSION = 1
    PROJECTION = {
      "type" => "linear-lat-lng-bounds",
      "x_axis" => "longitude-west-to-east",
      "z_axis" => "latitude-north-to-south",
      "elevation_unit" => "feet"
    }.freeze
    ISO8601 = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})\z/

    attr_reader :data, :sha256

    def self.write(payload, to:)
      data = JSON.parse(JSON.generate(payload)).merge(
        "schema_version" => SCHEMA_VERSION,
        "projection" => PROJECTION
      )
      new(data)
      bytes = "#{JSON.pretty_generate(data)}\n"

      output_path = Pathname(to)
      FileUtils.mkdir_p(output_path.dirname)
      File.binwrite(output_path, bytes)
      new(data, bytes: bytes)
    end

    def self.read(reference, from:, race_slug:)
      validate_reference!(reference)
      path = Pathname(from)
      invalid_reference!("file is missing") unless path.file?

      bytes = File.binread(path)
      sha256 = Digest::SHA256.hexdigest(bytes)
      invalid_reference!("SHA-256 digest does not match") unless sha256 == reference.fetch("sha256")

      artifact = new(JSON.parse(bytes), bytes: bytes)
      invalid_reference!("Race slug does not match") unless artifact.data.dig("race", "slug") == race_slug
      artifact
    rescue JSON::ParserError => error
      raise Invalid, "Invalid Terrain artifact: JSON could not be parsed (#{error.message})"
    end

    def self.runtime_reference(reference)
      validate_reference!(reference)
      separator = reference.fetch("path").include?("?") ? "&" : "?"
      reference.merge("path" => "#{reference.fetch('path')}#{separator}v=#{reference.fetch('sha256')}")
    end

    def self.validate_reference!(reference)
      invalid_reference!("reference is missing") unless reference.is_a?(Hash)
      invalid_reference!("status is not generated") unless reference["status"] == "generated"
      invalid_reference!("path must identify an owned Terrain artifact") unless reference["path"].is_a?(String) && reference["path"].start_with?("/terrain/")
      invalid_reference!("schema version is unsupported") unless reference["schema_version"] == SCHEMA_VERSION
      invalid_reference!("projection is unsupported") unless reference["projection"] == PROJECTION.fetch("type")
      invalid_reference!("SHA-256 digest is invalid") unless reference["sha256"].is_a?(String) && reference["sha256"].match?(/\A[0-9a-f]{64}\z/)
    end

    def self.invalid_reference!(message)
      raise Invalid, "Invalid Terrain artifact reference: #{message}"
    end
    private_class_method :validate_reference!, :invalid_reference!

    def initialize(data, bytes: nil)
      @data = deep_freeze(data)
      validate!
      @sha256 = Digest::SHA256.hexdigest(bytes || JSON.generate(data))
    end

    def reference(path:)
      {
        "status" => "generated",
        "path" => path,
        "schema_version" => SCHEMA_VERSION,
        "sha256" => sha256,
        "projection" => PROJECTION.fetch("type")
      }
    end

    private

    def deep_freeze(value)
      case value
      when Hash
        value.each { |key, nested| deep_freeze(key); deep_freeze(nested) }
      when Array
        value.each { |nested| deep_freeze(nested) }
      end
      value.freeze
    end

    def validate!
      invalid!("schema version is unsupported") unless data["schema_version"] == SCHEMA_VERSION
      invalid!("projection is unsupported") unless data["projection"] == PROJECTION

      race = data["race"]
      invalid!("race metadata is missing") unless race.is_a?(Hash)
      invalid!("race slug is missing") if race["slug"].blank?
      invalid!("race name is missing") if race["name"].blank?
      invalid!("race year is missing") unless race["year"].is_a?(Integer)
      validate_generated_at!

      source = data["source"]
      invalid!("source metadata is missing") unless source.is_a?(Hash)
      %w[label url attribution].each do |field|
        invalid!("source #{field} is missing") if source[field].blank?
      end

      grid = data["grid"]
      invalid!("grid is missing") unless grid.is_a?(Hash)
      size = grid["size"]
      invalid!("grid size must be at least 2") unless size.is_a?(Integer) && size >= 2
      invalid!("grid zoom is missing") unless grid["zoom"].is_a?(Integer)
      invalid!("grid elevations do not match its size") unless grid["elevations_ft"].is_a?(Array) && grid["elevations_ft"].size == size * size
      invalid!("grid elevations must be numeric") unless grid["elevations_ft"].all? { |value| finite_number?(value) }
      invalid!("grid elevation range is invalid") unless finite_number?(grid["min_ft"]) && finite_number?(grid["max_ft"]) && grid["min_ft"] <= grid["max_ft"]

      bounds = grid["bounds"]
      invalid!("grid bounds are missing") unless bounds.is_a?(Hash)
      %w[min_lat max_lat min_lng max_lng].each do |field|
        invalid!("grid bound #{field} is invalid") unless finite_number?(bounds[field])
      end
      invalid!("grid latitude bounds are invalid") unless bounds["min_lat"] < bounds["max_lat"]
      invalid!("grid longitude bounds are invalid") unless bounds["min_lng"] < bounds["max_lng"]

      profile = data["course_grade_profile"]
      invalid!("course grade profile is missing") unless profile.is_a?(Hash) && profile["segments"].is_a?(Array)
      profile["segments"].each do |segment|
        invalid!("course grade segment is invalid") unless segment.is_a?(Hash)
        %w[from to].each do |endpoint|
          coordinates = segment[endpoint]
          unless coordinates.is_a?(Array) && coordinates.size == 2 && coordinates.all? { |value| finite_number?(value) }
            invalid!("course grade segment #{endpoint} coordinates are invalid")
          end
        end
        invalid!("course grade segment grade is invalid") unless finite_number?(segment["grade_pct"])
        invalid!("course grade segment steepness is invalid") unless segment["steepness"].in?(%w[flat moderate steep])
      end
    end

    def validate_generated_at!
      generated_at = data["generated_at"]
      invalid!("generated at metadata is missing") unless generated_at.is_a?(String) && generated_at.match?(ISO8601)
      Time.iso8601(generated_at)
    rescue ArgumentError
      invalid!("generated at metadata is invalid")
    end

    def finite_number?(value)
      value.is_a?(Numeric) && value.finite?
    end

    def invalid!(message)
      raise Invalid, "Invalid Terrain artifact: #{message}"
    end
  end
end
