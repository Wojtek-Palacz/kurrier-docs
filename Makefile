# Kurrier User Stories Build System
# Main Makefile for generating HTML and PDF from AsciiDoc files

.PHONY: all html pdf clean clean-html clean-pdf clean-site help check-tools list-files site serve package

# Include common variables and rules
include makefiles/common.mk

# Default target
all: check-tools html pdf site

# Generate all HTML files
html: $(HTML_FILES)

# Generate all PDF files
pdf: $(PDF_FILES)

# Generate only Epic HTML files
html-epics: $(EPIC_HTML_FILES)

# Generate only Epic PDF files
pdf-epics: $(EPIC_PDF_FILES)

# Clean all generated files
clean: clean-html clean-pdf clean-site

# Clean only HTML files
clean-html:
	@echo "Cleaning HTML files..."
	@find UserStories -name "*.html" -type f -delete
	@echo "HTML files cleaned."

# Clean only PDF files
clean-pdf:
	@echo "Cleaning PDF files..."
	@find UserStories -name "*.pdf" -type f -delete
	@echo "PDF files cleaned."

# Rebuild everything
rebuild: clean all

# Generate static website
site: check-tools
	@echo "Generating static website..."
	@ruby generate_site.rb
	@echo ""
	@echo "✓ Website generated in site/"
	@echo "  Open site/index.html in your browser"

# Serve the site locally (requires Python)
serve: site
	@echo "Starting local web server..."
	@echo "Open http://localhost:8000 in your browser"
	@echo "Press Ctrl+C to stop"
	@cd site && python3 -m http.server 8000

# Clean site directory
clean-site:
	@echo "Cleaning site directory..."
	@rm -rf site
	@echo "Site directory cleaned."

# Package site as timestamped zip file
package: site
	@echo "Packaging site into timestamped zip..."
	@mkdir -p site-zipped
	@TIMESTAMP=$$(date +%y%m%d-%H%M); \
	ZIP_FILE="site-zipped/kurrier-site_$$TIMESTAMP.zip"; \
	cd site && zip -r ../$$ZIP_FILE . && cd ..; \
	echo "✓ Site packaged as $$ZIP_FILE"

# List all source and target files
list-files:
	@echo "AsciiDoc Source Files ($(words $(ADOC_FILES)) files):"
	@echo "---------------------------------------------------"
	@for file in $(ADOC_FILES); do echo "  $$file"; done
	@echo ""
	@echo "Epic Files ($(words $(EPIC_ADOC_FILES)) files):"
	@echo "----------------------------------------------"
	@for file in $(EPIC_ADOC_FILES); do echo "  $$file"; done

# Show help
help:
	@echo "Kurrier User Stories Build System"
	@echo "=================================="
	@echo ""
	@echo "Available targets:"
	@echo "  all          - Generate all HTML, PDF files, and static site (default)"
	@echo "  html         - Generate all HTML files from .adoc sources"
	@echo "  pdf          - Generate all PDF files from .adoc sources"
	@echo "  html-epics   - Generate HTML files for Epics only"
	@echo "  pdf-epics    - Generate PDF files for Epics only"
	@echo "  site         - Generate static website in site/ directory"
	@echo "  serve        - Generate site and start local web server on port 8000"
	@echo "  package      - Create timestamped zip in site-zipped/ (kurrier-site_yymmdd-hhmm.zip)"
	@echo "  clean        - Remove all generated files (HTML, PDF, site)"
	@echo "  clean-html   - Remove all generated HTML files"
	@echo "  clean-pdf    - Remove all generated PDF files"
	@echo "  clean-site   - Remove site directory"
	@echo "  rebuild      - Clean and rebuild all files"
	@echo "  list-files   - List all source .adoc files to be processed"
	@echo "  check-tools  - Verify required tools are installed"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make            - Generate all HTML, PDF files, and static site"
	@echo "  make html       - Generate HTML files only"
	@echo "  make site       - Generate static website"
	@echo "  make serve      - Generate and serve website locally"
	@echo "  make package    - Create timestamped zip of site"
	@echo "  make rebuild    - Clean and regenerate everything"
