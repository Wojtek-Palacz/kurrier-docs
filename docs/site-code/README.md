# Kurrier User Stories

Comprehensive user stories and documentation for the Kurrier last-mile parcel pickup platform.

## Quick Start

### Generate Everything (Recommended)

```bash
# Generate HTML files, PDF files, and static website
make
# or
make all
```

### Static Website

```bash
# Generate just the static website
make site

# Generate and serve locally at http://localhost:8000
make serve

# Package site as timestamped zip file
make package
# Creates: site-zipped/kurrier-site_251029-2247.zip
```

### Individual Files

```bash
# Generate only HTML files
make html

# Generate only PDF files
make pdf
```

## Project Structure

```
Kurrier/
├── UserStories/           # Source AsciiDoc files
│   ├── Epics/            # Epic user stories (E1-E10)
│   ├── Stories/          # Generated individual story files
│   └── index.adoc        # Auto-generated index
├── site/                 # Generated static website
│   ├── index.html        # Main overview page
│   ├── epics/            # Individual epic pages with story links
│   ├── stories/          # Individual story pages (44 stories)
│   └── assets/css/       # Stylesheets (vibrant color theme)
├── site-zipped/          # Packaged zip files
│   └── kurrier-site_*.zip
├── makefiles/            # Build system modules
├── generate_site.rb      # Static site generator (Ruby)
└── Makefile              # Build automation

```

## Features

### Static Website Generator

The `generate_site.rb` script automatically:
- Scans all Epic .adoc files
- Extracts metadata (ID, title, priority, actor, story count)
- **Extracts individual user stories from each epic** (44 stories total)
- Generates styled HTML pages for each epic with story links
- **Generates separate pages for each individual story**
- Creates an index page with epic summaries and navigation
- **Adds breadcrumb navigation** (🏠 Home › Epic › Story)
- Applies professional vibrant color CSS theme
- Adds back-navigation links with gradient styling

**Self-contained:** Requires only Ruby + asciidoctor gem (no LLM support needed)

**Navigation Features:**
- Top-level index with all epics
- Epic pages with story links and priority previews
- Individual story pages with full details
- Breadcrumb navigation on every page
- Back-to-epic links on story pages

**Color Palette:**
- Medium blue, sky blue, coral pink
- Mint green, periwinkle, golden orange
- Multi-color gradients and colored borders
- Blue-tinted shadows and yellow highlights

### Build System

The Makefile provides targets for:
- HTML generation from .adoc sources
- PDF generation from .adoc sources
- Static website generation
- Timestamped zip packaging for distribution
- Local web server for preview
- Clean operations for all artifacts

## Requirements

### Core Tools

- **asciidoctor** - For HTML generation
  ```bash
  gem install asciidoctor
  ```

- **asciidoctor-pdf** - For PDF generation
  ```bash
  gem install asciidoctor-pdf
  ```

### Optional Tools

- **Python 3** - For local web server (`make serve`)
- **Ruby** - For site generator (usually pre-installed on macOS)

## Usage

### Static Website

```bash
# Generate complete website
make site
# Output: site/index.html and site/epics/*.html

# Generate and serve locally
make serve
# Opens http://localhost:8000
# Press Ctrl+C to stop server

# Package site as timestamped zip for distribution
make package
# Output: site-zipped/kurrier-site_251029-2247.zip (timestamp format: yymmdd-hhmm)

# Or run the generator directly
ruby generate_site.rb
```

### Document Generation

```bash
# Generate all formats (HTML, PDF, and site)
make
# or
make all

# Generate specific epic HTML
make UserStories/Epics/Epic_E1_Consumer_Onboarding.html

# Generate specific epic PDF
make UserStories/Epics/Epic_E8_Job_Discovery.pdf

# Generate only Epic HTML files
make html-epics

# Generate only Epic PDF files
make pdf-epics
```

### Maintenance

```bash
# Clean all generated files
make clean

# Clean only website
make clean-site

# Clean and rebuild everything
make rebuild

# List all source files
make list-files

# Verify tools are installed
make check-tools

# Show all available targets
make help
```

## Epic Overview

The platform is organized into 10 epics:

### Consumer Epics (E1-E6)

1. **E1: Consumer Onboarding & Authentication** - Sign-in, permissions, profile setup
2. **E2: Shipment Creation & Booking** - Addresses, parcel details, special instructions
3. **E3: Service Selection & Quotation** - Multi-carrier quotes, comparison, selection
4. **E4: Payment & Confirmation** - Secure payment, booking confirmation
5. **E5: Live Tracking & Driver Interaction** - Real-time tracking, driver info, contact
6. **E6: Shipment Management & History** - Past shipments, receipts, loyalty rewards

### Driver Epics (E7-E10)

7. **E7: Driver Onboarding & Verification** - Registration, document upload, approval
8. **E8: Job Discovery & Acceptance** - Availability control, job listing, acceptance
9. **E9: Pickup & Hub Fulfillment** - Navigation, pickup, verification, hub delivery
10. **E10: Driver Earnings & Performance** - Earnings dashboard, payouts, ratings

## Documentation Standards

### AsciiDoc Format

All user stories are written in AsciiDoc with:
- Table of contents (left sidebar)
- Section numbering
- Font icons
- Syntax highlighting
- Proper bullet list formatting (empty line before first item)

### File Naming

- Epics: `Epic_E{N}_{Name}.adoc` (e.g., `Epic_E1_Consumer_Onboarding.adoc`)
- Story IDs: `{Actor}-E{Epic}-{Story}` (e.g., `C-E1-01`, `D-E8-02`)

## Site Generator Details

The `generate_site.rb` script is a self-contained Ruby application that:

1. **Scans** all .adoc files in `UserStories/Epics/`
2. **Extracts** metadata using regex pattern matching
3. **Generates** HTML using asciidoctor Ruby API
4. **Applies** professional CSS theming
5. **Creates** navigation and index pages
6. **Outputs** to `site/` directory

**No external dependencies** beyond the asciidoctor gem. Can run independently without any LLM or external services.

## Customization

### AsciiDoc Options

Edit `makefiles/common.mk` to modify:
- `ADOC_OPTS` - HTML generation options
- `ADOC_PDF_OPTS` - PDF generation options

### CSS Styling

Edit the `generate_css` method in `generate_site.rb` to customize the website theme.

### Site Structure

Modify the `generate_index_adoc` method in `generate_site.rb` to change the index page layout and content.

## Maintenance

The site generator is designed to be low-maintenance:

- **No configuration files** - Everything is code
- **Automatic discovery** - Finds all .adoc files automatically
- **Metadata extraction** - Reads directly from .adoc content
- **Self-contained** - No external services required
- **Version controlled** - All code in this repository

## Support

For build system documentation, see:
- `makefiles/README.md` - Detailed Makefile usage
- `make help` - Quick reference

## License

Kurrier Inc. - Internal Documentation
