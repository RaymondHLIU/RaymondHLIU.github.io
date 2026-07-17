# Hao Liu — Academic Website

Source for [raymondhliu.github.io](https://raymondhliu.github.io), built with Jekyll and deployed by GitHub Pages.

## Content map

- `_pages/`: page content and structure
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
ruby scripts/validate_publications.rb
```

If JavaScript sources change, install the pinned build dependency and regenerate the bundle:

```bash
npm install
npm run build:js
```
