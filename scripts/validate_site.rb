#!/usr/bin/env ruby

require "pathname"
require "uri"

build_dir = Pathname.new(ARGV.fetch(0) do
  abort "Usage: ruby scripts/validate_site.rb BUILD_DIRECTORY"
end).expand_path

core_pages = %w[
  index.html
  news/index.html
  research/index.html
  publications/index.html
  publications/full/index.html
  teaching/index.html
  students/index.html
  services/index.html
]

errors = []

core_pages.each do |relative_path|
  page_path = build_dir.join(relative_path)
  unless page_path.file?
    errors << "#{relative_path}: generated page is missing"
    next
  end

  html = page_path.read
  errors << "#{relative_path}: expected exactly one h1" unless html.scan(/<h1\b/i).size == 1
  errors << "#{relative_path}: missing document title" unless html.match?(/<title>[^<]+<\/title>/i)
  errors << "#{relative_path}: missing meta description" unless html.match?(/<meta name="description" content="[^"]+">/i)
  errors << "#{relative_path}: missing Open Graph description" unless html.match?(/<meta property="og:description" content="[^"]+">/i)
  errors << "#{relative_path}: unbalanced script tags" unless html.scan(/<script\b/i).size == html.scan(/<\/script>/i).size

  ids = html.scan(/\sid="([^"]+)"/i).flatten
  duplicate_ids = ids.group_by(&:itself).select { |_id, values| values.size > 1 }.keys
  errors << "#{relative_path}: duplicate IDs #{duplicate_ids.join(', ')}" unless duplicate_ids.empty?

  html.scan(/<img\b[^>]*>/i).each do |image_tag|
    errors << "#{relative_path}: image is missing alt text" unless image_tag.match?(/\salt="[^"]*"/i)
  end

  html.scan(/\s(?:href|src)="([^"]*)"/i).flatten.each do |url|
    if url.empty?
      errors << "#{relative_path}: empty link or asset URL"
      next
    end

    next if url.start_with?("#", "mailto:", "tel:", "javascript:", "data:", "http://", "https://", "//")

    local_path = url.split(/[?#]/, 2).first.delete_prefix("/")
    target = build_dir.join(local_path)
    target = target.join("index.html") if local_path.empty? || url.split(/[?#]/, 2).first.end_with?("/")
    errors << "#{relative_path}: missing internal target #{url}" unless target.file?
  end
end

unless errors.empty?
  warn errors.map { |error| "- #{error}" }.join("\n")
  exit 1
end

puts "Validated #{core_pages.size} core pages, their metadata, IDs, images, scripts, and internal links."
