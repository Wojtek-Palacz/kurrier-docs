# Kurrier Build System

This directory contains Makefiles for automating the generation of HTML and PDF documentation from AsciiDoc source files.

## Structure

- `common.mk` - Common variables, tool definitions, and pattern rules for AsciiDoc conversion

## Prerequisites

The build system requires the following tools:

1. **asciidoctor** - For HTML generation
   ```bash
   gem install asciidoctor
   ```

2. **asciidoctor-pdf** - For PDF generation
   ```bash
   gem install asciidoctor-pdf
   ```

## Usage

From the project root directory, run:

```bash
# Generate static website (recommended)
make site

# Generate and serve website locally at http://localhost:8000
make serve

# Package site as timestamped zip file
make package

# Generate all HTML, PDF files, and static site
make

# Generate only HTML files
make html

# Generate only PDF files
make pdf

# Generate Epic HTML files only
make html-epics

# Generate Epic PDF files only
make pdf-epics

# Build a specific file
make UserStories/Demo_Golden_Path.html
make UserStories/Epics/Epic_E1_Consumer_Onboarding.pdf

# List all source files that will be processed
make list-files

# Check if required tools are installed
make check-tools

# Clean all generated files
make clean

# Clean only website
make clean-site

# Clean and rebuild everything
make rebuild

# Show help
make help
```

## How It Works

### Static Website Generation

The `make site` target invokes `generate_site.rb`, a self-contained Ruby script that:

1. Scans all Epic .adoc files in `UserStories/Epics/`
2. Extracts metadata (Epic ID, title, priority, actor, story count, goal)
3. Generates styled HTML pages with navigation in `site/epics/`
4. Creates a comprehensive index page in `site/index.html`
5. Applies professional CSS theming

**Output:** A complete static website in the `site/` directory that can be:
- Opened directly in a browser (`site/index.html`)
- Served locally with `make serve` (requires Python 3)
- Deployed to any static hosting service

### Individual File Generation

1. The build system automatically discovers all `.adoc` files in the `UserStories` directory
2. For each `.adoc` file, it generates corresponding `.html` and `.pdf` files in the same location
3. Pattern rules ensure that files are only regenerated when the source `.adoc` file is newer than the target

## Customization

### AsciiDoc Options

To modify the AsciiDoc processing options, edit the variables in `makefiles/common.mk`:

- `ADOC_OPTS` - Options for HTML generation
- `ADOC_PDF_OPTS` - Options for PDF generation

### Adding New Targets

To add new make targets, edit the main `Makefile` in the project root.
