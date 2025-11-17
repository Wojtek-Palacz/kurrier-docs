# Common variables and rules for AsciiDoc processing

# Tools
ASCIIDOCTOR = asciidoctor
ASCIIDOCTOR_PDF = asciidoctor-pdf

# AsciiDoc options
ADOC_OPTS = -a toc=left -a toclevels=3 -a icons=font -a source-highlighter=rouge
ADOC_PDF_OPTS = -a pdf-theme=default -a toc -a toclevels=3 -a source-highlighter=rouge

# Find all .adoc source files
ADOC_FILES := $(shell find UserStories -name "*.adoc" -type f)

# Generate target file lists
HTML_FILES := $(ADOC_FILES:.adoc=.html)
PDF_FILES := $(ADOC_FILES:.adoc=.pdf)

# Epic-specific files
EPIC_ADOC_FILES := $(shell find UserStories/Epics -name "*.adoc" -type f)
EPIC_HTML_FILES := $(EPIC_ADOC_FILES:.adoc=.html)
EPIC_PDF_FILES := $(EPIC_ADOC_FILES:.adoc=.pdf)

# Pattern rule: .adoc -> .html
%.html: %.adoc
	@echo "Generating HTML: $@"
	@$(ASCIIDOCTOR) $(ADOC_OPTS) -o $@ $<

# Pattern rule: .adoc -> .pdf
%.pdf: %.adoc
	@echo "Generating PDF: $@"
	@$(ASCIIDOCTOR_PDF) $(ADOC_PDF_OPTS) -o $@ $<

# Check if tools are installed
.PHONY: check-tools
check-tools:
	@command -v $(ASCIIDOCTOR) >/dev/null 2>&1 || { echo "Error: asciidoctor not found. Install with: gem install asciidoctor"; exit 1; }
	@command -v $(ASCIIDOCTOR_PDF) >/dev/null 2>&1 || { echo "Error: asciidoctor-pdf not found. Install with: gem install asciidoctor-pdf"; exit 1; }
