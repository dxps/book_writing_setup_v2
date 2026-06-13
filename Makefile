SHELL := /bin/sh

SRC := book.adoc
BUILD_DIR := build
BOOK_ID := technical-book

export BUNDLE_APP_CONFIG := .bundle
export BUNDLE_PATH := vendor/bundle

BUNDLE := bundle exec
ASCIIDOCTOR := $(BUNDLE) asciidoctor
ASCIIDOCTOR_PDF := $(BUNDLE) asciidoctor-pdf
ASCIIDOCTOR_EPUB3 := $(BUNDLE) asciidoctor-epub3
RUBY3_CHECK := ruby -e 'current = Gem::Version.new(RUBY_VERSION); required = Gem::Version.new("3.0.0"); abort("Ruby 3.0+ is required; current version is " + RUBY_VERSION) if current < required'

COMMON_ATTRS := \
	-a source-highlighter=rouge \
	-a rouge-style=github \
	-a imagesdir=assets/images \
	-a experimental

.PHONY: all setup clean html pdf epub web serve doctor

all: html pdf epub

setup:
	$(RUBY3_CHECK)
	bundle config set path $(BUNDLE_PATH)
	bundle install

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

html: $(BUILD_DIR)
	$(ASCIIDOCTOR) $(COMMON_ATTRS) \
		-a stylesheet=theme/html.css \
		-D $(BUILD_DIR) \
		-o index.html \
		$(SRC)

web: html

pdf: $(BUILD_DIR)
	$(ASCIIDOCTOR_PDF) $(COMMON_ATTRS) \
		-a pdf-theme=theme/pdf-theme.yml \
		-a pdf-fontsdir=theme/fonts,GEM_FONTS_DIR \
		-D $(BUILD_DIR) \
		-o $(BOOK_ID).pdf \
		$(SRC)

epub: $(BUILD_DIR)
	$(ASCIIDOCTOR_EPUB3) $(COMMON_ATTRS) \
		-a stylesheet=theme/epub.css \
		-D $(BUILD_DIR) \
		-o $(BOOK_ID).epub \
		$(SRC)

serve: html
	ruby -run -e httpd $(BUILD_DIR) -p 8000

doctor:
	@ruby --version
	@$(RUBY3_CHECK)
	@bundle --version
	@$(ASCIIDOCTOR) --version
	@$(ASCIIDOCTOR_PDF) --version
	@$(ASCIIDOCTOR_EPUB3) --version

clean:
	rm -rf $(BUILD_DIR)
