#!/usr/bin/env ruby

require "yaml"

ROOT = File.expand_path("..", __dir__)
FULL_LIST_PATH = File.join(ROOT, "_data", "publications.yml")
SELECTED_PATH = File.join(ROOT, "_data", "selected_publications.yml")

def normalize_title(title)
  title.downcase.gsub(/[^a-z0-9]+/, " ").strip
end

full_data = YAML.load_file(FULL_LIST_PATH)
selected_themes = YAML.load_file(SELECTED_PATH)
full_groups = full_data.fetch("groups")
full_citations = full_groups.flat_map { |group| group.fetch("papers") }
selected_papers = selected_themes.flat_map { |theme| theme.fetch("papers") }
errors = []

full_links = {}
full_citations.each do |citation|
  citation.scan(/\[([^\]]+)\]\(([^)]+)\)/).each do |title, url|
    full_links[normalize_title(title)] = url
  end
end

selected_papers.each do |paper|
  label = paper.fetch("short_title", paper.fetch("title"))
  full_title = paper.fetch("full_list_title", paper.fetch("title"))
  full_url = full_links[normalize_title(full_title)]

  errors << "#{label}: missing from full publication list" unless full_url
  if full_url && full_url != paper.fetch("url")
    errors << "#{label}: Paper URL differs between selected and full lists"
  end

  %w[image bibtex].each do |field|
    path = paper[field]
    errors << "#{label}: missing #{field}" unless path
    errors << "#{label}: #{field} file not found at #{path}" if path && !File.exist?(File.join(ROOT, path.delete_prefix("/")))
  end

  if paper["bibtex"]
    bibtex_path = File.join(ROOT, paper["bibtex"].delete_prefix("/"))
    if File.exist?(bibtex_path)
      bibtex = File.read(bibtex_path)
      bibtex_title = bibtex[/^\s*title\s*=\s*\{(.*)\},?\s*$/i, 1]
      if bibtex_title.nil?
        errors << "#{label}: BibTeX title is missing or split across lines"
      elsif normalize_title(bibtex_title.delete("{}")) != normalize_title(paper.fetch("title"))
        errors << "#{label}: title differs between selected card and BibTeX"
      end
    end
  end

  supplemental_labels = Array(paper["links"]).map { |link| link.fetch("label") }
  errors << "#{label}: Paper belongs in the primary url field, not supplemental links" if supplemental_labels.include?("Paper")
  errors << "#{label}: duplicate supplemental link labels" unless supplemental_labels.uniq.size == supplemental_labels.size
end

errors << "Duplicate selected-publication titles" unless selected_papers.map { |paper| normalize_title(paper.fetch("title")) }.uniq.size == selected_papers.size
errors << "Duplicate publication theme IDs" unless selected_themes.map { |theme| theme.fetch("id") }.uniq.size == selected_themes.size

unless errors.empty?
  warn errors.map { |error| "- #{error}" }.join("\n")
  exit 1
end

code_links = selected_papers.sum do |paper|
  Array(paper["links"]).count { |link| link.fetch("label") == "Code" }
end

puts "Validated #{full_citations.size} full-list publications across #{full_groups.size} year groups."
puts "Validated #{selected_papers.size} selected publications, #{selected_papers.size} BibTeX files, and #{code_links} code links."
