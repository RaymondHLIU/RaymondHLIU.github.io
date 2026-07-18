#!/usr/bin/env ruby

require "date"
require "yaml"

ROOT = File.expand_path("..", __dir__)
DATA_DIR = File.join(ROOT, "_data")

errors = []

def load_data(name)
  YAML.safe_load(
    File.read(File.join(DATA_DIR, "#{name}.yml")),
    permitted_classes: [Date, Time],
    aliases: true
  )
end

def require_fields(item, fields, context, errors)
  fields.each do |field|
    value = item[field]
    errors << "#{context}: missing #{field}" if value.nil? || (value.respond_to?(:empty?) && value.empty?)
  end
end

def validate_url(url, context, errors)
  unless url.match?(%r{\A(?:https?://|mailto:|#|/)})
    errors << "#{context}: unsupported URL #{url}"
    return
  end

  return unless url.start_with?("/") && File.extname(url.split(/[?#]/, 2).first) != ""

  local_path = File.join(ROOT, url.split(/[?#]/, 2).first.delete_prefix("/"))
  errors << "#{context}: local target not found at #{url}" unless File.file?(local_path)
end

def validate_links_in_markdown(content, context, errors)
  content.to_s.scan(/\[[^\]]+\]\(([^)]+)\)/).flatten.each do |url|
    validate_url(url, context, errors)
  end
end

def normalized_date(value)
  string = value.to_s
  case string
  when /\A\d{4}\z/ then Date.iso8601("#{string}-01-01")
  when /\A\d{4}-\d{2}\z/ then Date.iso8601("#{string}-01")
  else Date.iso8601(string)
  end
end

profile = load_data("profile")
require_fields(profile, %w[name affiliation bio portrait links footer_links], "profile", errors)
require_fields(profile.fetch("portrait", {}), %w[src alt], "profile.portrait", errors)
validate_url(profile.dig("portrait", "src"), "profile.portrait", errors) if profile.dig("portrait", "src")

site_config = YAML.safe_load(File.read(File.join(ROOT, "_config.yml")), aliases: true)
errors << "profile.name: does not match _config.yml name" unless profile["name"] == site_config["name"]
errors << "profile.name: does not match _config.yml author name" unless profile["name"] == site_config.dig("author", "name")
portrait_filename = File.basename(profile.dig("portrait", "src").to_s)
errors << "profile.portrait: does not match _config.yml author avatar" unless portrait_filename == site_config.dig("author", "avatar")

%w[links footer_links].each do |section|
  Array(profile[section]).each_with_index do |link, index|
    context = "profile.#{section}[#{index}]"
    require_fields(link, %w[label url], context, errors)
    validate_url(link["url"], context, errors) if link["url"]
  end
  labels = Array(profile[section]).map { |link| link["label"] }
  errors << "profile.#{section}: duplicate labels" unless labels.uniq.size == labels.size
end

home = load_data("home")
research_summary = home.fetch("research", {})
join = home.fetch("join", {})
require_fields(research_summary, %w[heading lead capabilities link], "home.research", errors)
capabilities = Array(research_summary["capabilities"])
errors << "home.research: expected three capabilities" unless capabilities.size == 3
capabilities.each_with_index do |capability, index|
  require_fields(capability, %w[number title description], "home.research.capabilities[#{index}]", errors)
end
numbers = capabilities.map { |capability| capability["number"] }
errors << "home.research: duplicate capability numbers" unless numbers.uniq.size == numbers.size
require_fields(research_summary.fetch("link", {}), %w[label url], "home.research.link", errors)
validate_url(research_summary.dig("link", "url"), "home.research.link", errors) if research_summary.dig("link", "url")

require_fields(join, %w[eyebrow title opportunities], "home.join", errors)
opportunities = Array(join["opportunities"])
errors << "home.join: expected at least one opportunity" if opportunities.empty?
opportunities.each_with_index do |opportunity, index|
  context = "home.join.opportunities[#{index}]"
  require_fields(opportunity, %w[title content], context, errors)
  validate_links_in_markdown(opportunity["content"], context, errors)
end

news = load_data("news").fetch("items", [])
errors << "news: no items" if news.empty?
news_dates = []
news.each_with_index do |item, index|
  context = "news.items[#{index}]"
  require_fields(item, %w[date display content], context, errors)
  begin
    news_dates << normalized_date(item["date"])
  rescue Date::Error
    errors << "#{context}: invalid date #{item['date']}"
  end
  validate_links_in_markdown(item["content"], context, errors)
  validate_links_in_markdown(item["summary"], "#{context}.summary", errors) if item["summary"]
end
errors << "news: items are not in reverse chronological order" unless news_dates == news_dates.sort.reverse
news_keys = news.map { |item| [item["date"].to_s, item["content"]] }
errors << "news: duplicate entries" unless news_keys.uniq.size == news_keys.size
errors << "news: homepage requires at least five featured items" if news.count { |item| item["featured"] } < 5

teaching = load_data("teaching")
course_keys = []
%w[current past].each do |section|
  courses = Array(teaching[section])
  errors << "teaching.#{section}: no courses" if courses.empty?
  courses.each_with_index do |course, index|
    context = "teaching.#{section}[#{index}]"
    require_fields(course, %w[term code title], context, errors)
    errors << "#{context}: invalid term #{course['term']}" unless course["term"].to_s.match?(/\A\d{4} (?:Spring|Summer|Fall|Winter)\z/)
    course_keys << [course["term"], course["code"]]
  end
end
errors << "teaching: duplicate term and course-code pairs" unless course_keys.uniq.size == course_keys.size

students = load_data("students")
achievements = Array(students["achievements"])
achievement_years = achievements.map { |achievement| achievement["year"].to_i }
errors << "students.achievements: not ordered by year" unless achievement_years == achievement_years.sort.reverse
achievements.each_with_index do |achievement, index|
  context = "students.achievements[#{index}]"
  require_fields(achievement, %w[name year award], context, errors)
  validate_url(achievement["url"], context, errors) if achievement["url"]
end

alumni = students.fetch("alumni", {})
student_alumni = Array(alumni["students"])
assistant_alumni = Array(alumni["assistants"])
student_alumni.each_with_index do |person, index|
  require_fields(person, %w[name degree year destination], "students.alumni.students[#{index}]", errors)
end
years = student_alumni.map { |person| person["year"].to_i }
errors << "students.alumni.students: not ordered by year" unless years == years.sort.reverse
assistant_alumni.each_with_index do |person, index|
  require_fields(person, %w[name role background], "students.alumni.assistants[#{index}]", errors)
end
alumni_names = (student_alumni + assistant_alumni).map { |person| person["name"] }
errors << "students.alumni: duplicate people" unless alumni_names.uniq.size == alumni_names.size

services = load_data("services")
editorial = Array(services["editorial_and_organizational"])
conferences = Array(services["conferences"])
journals = Array(services["journals"])
errors << "services.editorial_and_organizational: no entries" if editorial.empty?
errors << "services.conferences: no entries" if conferences.empty?
errors << "services.journals: no entries" if journals.empty?
editorial.each_with_index do |service, index|
  context = "services.editorial_and_organizational[#{index}]"
  require_fields(service, %w[organization role], context, errors)
  validate_url(service["url"], context, errors) if service["url"]
end
conferences.each_with_index do |conference, index|
  require_fields(conference, %w[name years], "services.conferences[#{index}]", errors)
end
errors << "services.journals: duplicate entries" unless journals.uniq.size == journals.size

research = load_data("research")
require_fields(research, %w[lead framework perspectives themes full_publications], "research", errors)
framework = research.fetch("framework", {})
require_fields(framework, %w[desktop_image mobile_image alt caption], "research.framework", errors)
%w[desktop_image mobile_image].each do |field|
  validate_url(framework[field], "research.framework.#{field}", errors) if framework[field]
end

Array(research["perspectives"]).each_with_index do |paper, index|
  context = "research.perspectives[#{index}]"
  require_fields(paper, %w[title url], context, errors)
  validate_url(paper["url"], context, errors) if paper["url"]
end

themes = Array(research["themes"])
errors << "research.themes: expected three themes" unless themes.size == 3
themes.each_with_index do |theme, index|
  context = "research.themes[#{index}]"
  require_fields(theme, %w[id title image description related], context, errors)
  errors << "#{context}: invalid id #{theme['id']}" unless theme["id"].to_s.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
  validate_url(theme["image"], context, errors) if theme["image"]
  errors << "#{context}: no related work" if Array(theme["related"]).empty?
  Array(theme["related"]).each_with_index do |paper, paper_index|
    paper_context = "#{context}.related[#{paper_index}]"
    require_fields(paper, %w[title url], paper_context, errors)
    validate_url(paper["url"], paper_context, errors) if paper["url"]
  end
end
theme_ids = themes.map { |theme| theme["id"] }
errors << "research.themes: duplicate IDs" unless theme_ids.uniq.size == theme_ids.size
require_fields(research.fetch("full_publications", {}), %w[label url], "research.full_publications", errors)
validate_url(research.dig("full_publications", "url"), "research.full_publications", errors) if research.dig("full_publications", "url")

talks = load_data("talks").fetch("items", [])
errors << "talks: no entries" if talks.empty?
talk_dates = []
talks.each_with_index do |talk, index|
  context = "talks.items[#{index}]"
  require_fields(talk, %w[title format venue date], context, errors)
  validate_url(talk["venue_url"], context, errors) if talk["venue_url"]
  begin
    talk_dates << Date.iso8601(talk["date"].to_s)
  rescue Date::Error
    errors << "#{context}: invalid date #{talk['date']}"
  end
end
errors << "talks: entries are not in reverse chronological order" unless talk_dates == talk_dates.sort.reverse
talk_keys = talks.map { |talk| [talk["title"], talk["date"].to_s] }
errors << "talks: duplicate entries" unless talk_keys.uniq.size == talk_keys.size

unless errors.empty?
  warn errors.map { |error| "- #{error}" }.join("\n")
  exit 1
end

puts "Validated structured content: #{news.size} news items, #{course_keys.size} courses, #{achievements.size} achievements, #{alumni_names.size} alumni, #{editorial.size + conferences.size + journals.size} service entries, #{themes.size} research themes, and #{talks.size} talks."
