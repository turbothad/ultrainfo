namespace :terrain do
  desc "Preprocess terrain JSON for a race slug"
  task :preprocess, [ :slug ] => :environment do |_task, args|
    slug = args[:slug].presence or abort "Usage: bin/rails terrain:preprocess[slug]"
    race = Race.find_by!(slug: slug)
    path = Rails.root.join("public/terrain/#{race.slug}.json")
    artifact = Terrain::Preprocess.new(race, output_path: path).call
    puts "Wrote #{path.relative_path_from(Rails.root)}"
    size = artifact.dig("grid", "size")
    puts "Grid #{size}x#{size} / #{artifact.dig('grid', 'min_ft')}-#{artifact.dig('grid', 'max_ft')} ft"
  end
end
