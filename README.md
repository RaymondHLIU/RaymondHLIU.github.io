# Hao Liu — Academic Website

Source for [raymondhliu.github.io](https://raymondhliu.github.io), built with Jekyll and deployed by GitHub Pages.

## Content map

- `_pages/`: page content and structure
- `_data/profile.yml`: bio, portrait, profile links, and footer links
- `_data/home.yml`: homepage research summary and Join Us opportunities
- `_data/news.yml`: shared source for homepage updates and the full News archive
- `_data/teaching.yml`: current and past courses
- `_data/students.yml`: student achievements and alumni
- `_data/services.yml`: editorial, conference, and journal service
- `_data/research.yml`: research framework, perspectives, themes, and related work
- `_data/talks.yml`: talks and presentations
- `_data/publications.yml`: full publication list
- `_data/selected_publications.yml`: selected-publication cards
- `_sass/_homepage.scss`: site-specific visual system and responsive layout
- `images/research/`: research-theme diagrams
- `files/bibtex/`: publication BibTeX files

## Local preview

Use the Ruby version currently supported by [GitHub Pages](https://pages.github.com/versions/), then run:

```bash
bundle install
bundle exec jekyll serve --config _config.yml,_config.dev.yml
```

The site is available at `http://localhost:4000/`. Generated files in `_site/` are intentionally not committed. `Gemfile.lock` is also not committed because production uses GitHub Pages' managed dependency set; installing the `github-pages` meta-gem keeps local builds aligned with the current platform release.

## Validation

After content or layout changes:

```bash
bundle exec jekyll build --destination /tmp/raymondhliu-site
ruby scripts/validate_site.rb /tmp/raymondhliu-site
ruby scripts/validate_content.rb
ruby scripts/validate_publications.rb
```

GitHub Actions also runs the structured-content and publication checks automatically on every push and pull request.

## Updating content

Frequently edited content lives in `_data/` rather than page templates. Add or edit a YAML entry, keep the existing field names, and run the validation commands above. Page files in `_pages/` should normally change only when the layout or information architecture changes.

See [MAINTENANCE.md](MAINTENANCE.md) for a Chinese content map and copy-ready update examples for news, courses, students, research themes, talks, Join Us, and publications.

News items are listed once in `_data/news.yml`. Set `featured: true` to make an item eligible for the five-entry homepage list, and add an optional `summary` when the homepage wording should be shorter than the archive entry. Inline links and emphasis use Markdown.

If JavaScript sources change, install the pinned build dependency and regenerate the bundle:

```bash
npm install
npm run build:js
```
