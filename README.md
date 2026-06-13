# Technical Book Writing Setup

This repository is a starter kit for writing a technical book in AsciiDoc and publishing it as:

- HTML for the web
- PDF for print-style reading
- EPUB for ebook readers

AsciiDoc is a strong fit for technical books because it has first-class support for chapters, includes, admonitions, code listings, callouts, cross references, tables, indexes, and multiple output formats from one source.

## Requirements

- Ruby 3.x
- Bundler

The project includes `.ruby-version` for version managers such as `mise`, `rbenv`, `chruby`, or `asdf`. Avoid using the macOS system Ruby for this project; it is usually too old for the current publishing gems.

### Ruby 3.x on macOS

On latest macOS, don’t replace the system Ruby. Leave `/usr/bin/ruby` alone and install Ruby 3 with a version manager. Use `mise` for this repo:

```sh
brew install mise
mise install ruby@3.3.6
mise use ruby@3.3.6
ruby --version
gem install bundler
make setup
make all
```

### Install the publishing tools:

```sh
make setup
```

## Build

```sh
make html
make pdf
make epub
make all
```

Outputs are written to `build/`:

- `build/index.html`
- `build/technical-book.pdf`
- `build/technical-book.epub`

Preview the web build locally:

```sh
make serve
```

Then open <http://localhost:8000>.

## Project Layout

```text
book.adoc              Main manuscript and book metadata
chapters/              Chapter source files
assets/images/         Images referenced by the book
examples/              Source files used in listings or exercises
theme/html.css         HTML styling
theme/pdf-theme.yml    PDF styling
theme/epub.css         EPUB styling hook
```

## Cover Image

Put the cover image under `assets/images/`, for example:

```text
assets/images/cover.png
```

Then enable the cover in `book.adoc` by adding this near the other document attributes:

```asciidoc
:front-cover-image: image:cover.png[Front Cover,1050,1600]
```

Because `book.adoc` already sets `:imagesdir: assets/images`, the cover path is relative to `assets/images/`.

Recommended cover sizes:

- EPUB: `1600x2560` or similar tall portrait ratio
- PDF: A4 portrait ratio works well, such as `1748x2480`

For PDF and EPUB, `:front-cover-image:` sets the generated book cover. For HTML, it does not automatically create a visual cover page in the body; add an image explicitly near the top of `book.adoc` if you want the web version to show it:

```asciidoc
image::cover.png[Book cover,role=cover]
```

## Writing Workflow

1. Edit `book.adoc` for metadata, front matter, and the table of contents.
2. Add chapters under `chapters/`.
3. Include chapters from `book.adoc` using `include::chapters/name.adoc[]`.
4. Put runnable code samples under `examples/` and include them with `include::examples/file.ext[]`.
5. Run `make all` before publishing.

## Publishing To The Web

The GitHub Actions workflow builds all formats on pushes to `main` and uploads the generated artifacts. To publish `build/index.html` with GitHub Pages, enable Pages for the repository and point it at the generated artifact or adapt the workflow to deploy to your preferred host.
