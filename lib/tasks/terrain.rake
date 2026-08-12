namespace :terrain do
  desc "Preprocess terrain JSON for a race slug"
  task :preprocess, [ :slug ] => :environment do |_task, args|
    slug = args[:slug].presence or abort "Usage: bin/rails terrain:preprocess[slug]"
    race = Race.find_by!(slug: slug)
    path = Rails.root.join("public/terrain/#{race.slug}.json")
    artifact = Terrain::Preprocess.new(race, output_path: path).call
    puts "Wrote #{path.relative_path_from(Rails.root)}"
    size = artifact.data.dig("grid", "size")
    puts "Grid #{size}x#{size} / #{artifact.data.dig('grid', 'min_ft')}-#{artifact.data.dig('grid', 'max_ft')} ft"
    puts "Schema #{Terrain::Artifact::SCHEMA_VERSION} / SHA-256 #{artifact.sha256}"
  end
end
