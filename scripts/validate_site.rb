#!/usr/bin/env ruby

require "pathname"
require "uri"
require "yaml"

source_dir = Pathname.new(File.expand_path("..", __dir__))

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
  cv/index.html
  talks/index.html
  terms/index.html
  aiaa5028/index.html
]

errors = []

def load_data(source_dir, name)
  YAML.safe_load(source_dir.join("_data", "#{name}.yml").read, aliases: true)
end

def class_count(html, class_name)
  html.scan(/class="[^"]*\b#{Regexp.escape(class_name)}\b[^"]*"/i).size
end

def container_child_counts(html, container_tag, class_name, child_tag)
  pattern = /<#{container_tag}\b[^>]*class="[^"]*\b#{Regexp.escape(class_name)}\b[^"]*"[^>]*>(.*?)<\/#{container_tag}>/mi
  html.scan(pattern).flatten.map { |contents| contents.scan(/<#{child_tag}\b/i).size }
end

def expect_count(actual, expected, context, errors)
  errors << "#{context}: rendered #{actual.inspect}, expected #{expected.inspect}" unless actual == expected
end

def generated_html(build_dir, relative_path)
  path = build_dir.join(relative_path)
  path.file? ? path.read : ""
end

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

# Cross-check the generated HTML against the structured content. This catches a
# valid YAML edit that is accidentally omitted by a page template.
home = load_data(source_dir, "home")
news = load_data(source_dir, "news").fetch("items", [])
teaching = load_data(source_dir, "teaching")
students = load_data(source_dir, "students")
services = load_data(source_dir, "services")
research = load_data(source_dir, "research")
talks = load_data(source_dir, "talks").fetch("items", [])

index_html = generated_html(build_dir, "index.html")
expect_count(class_count(index_html, "home-question"), home.dig("research", "capabilities").size, "index.html: research capabilities", errors)
expect_count(class_count(index_html, "home-update"), [news.count { |item| item["featured"] }, 5].min, "index.html: featured news", errors)
expect_count(container_child_counts(index_html, "div", "home-join", "article"), [home.dig("join", "opportunities").size], "index.html: Join Us opportunities", errors)

news_html = generated_html(build_dir, "news/index.html")
expect_count(class_count(news_html, "home-update"), news.size, "news/index.html: news entries", errors)

teaching_html = generated_html(build_dir, "teaching/index.html")
expected_course_counts = [teaching.fetch("current", []).size, teaching.fetch("past", []).size]
expect_count(container_child_counts(teaching_html, "ul", "course-history", "li"), expected_course_counts, "teaching/index.html: course groups", errors)

students_html = generated_html(build_dir, "students/index.html")
expect_count(container_child_counts(students_html, "ul", "achievement-list", "li"), [students.fetch("achievements", []).size], "students/index.html: achievements", errors)
expected_alumni_counts = [students.dig("alumni", "students").size, students.dig("alumni", "assistants").size]
expect_count(container_child_counts(students_html, "ul", "people-list", "li"), expected_alumni_counts, "students/index.html: alumni groups", errors)

services_html = generated_html(build_dir, "services/index.html")
expect_count(container_child_counts(services_html, "ul", "service-list", "li"), [services.fetch("editorial_and_organizational", []).size], "services/index.html: editorial and organizational service", errors)
expect_count(container_child_counts(services_html, "div", "service-grid", "article"), [services.fetch("conferences", []).size], "services/index.html: conference service", errors)
expect_count(container_child_counts(services_html, "ul", "journal-list", "li"), [services.fetch("journals", []).size], "services/index.html: journal reviewing", errors)

research_html = generated_html(build_dir, "research/index.html")
expect_count(class_count(research_html, "home-project"), research.fetch("themes", []).size, "research/index.html: research themes", errors)
expect_count(container_child_counts(research_html, "section", "research-perspectives", "li"), [research.fetch("perspectives", []).size], "research/index.html: surveys and perspectives", errors)

talks_html = generated_html(build_dir, "talks/index.html")
expect_count(container_child_counts(talks_html, "ul", "talk-list", "li"), [talks.size], "talks/index.html: talks", errors)

unless errors.empty?
  warn errors.map { |error| "- #{error}" }.join("\n")
  exit 1
end

puts "Validated #{core_pages.size} core pages, their metadata, IDs, images, scripts, internal links, and structured-content counts."
