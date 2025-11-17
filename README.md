# Kurrier

A user stories build system that converts AsciiDoc documentation into HTML, PDF, and static websites.

## Overview

Kurrier is a documentation and user story management system that processes AsciiDoc files to generate multiple output formats. It includes automated build tools, static site generation, and packaging capabilities for easy distribution.

## Features

- **Multi-format Output**: Generate HTML and PDF from AsciiDoc sources
- **Static Site Generation**: Create a browsable static website from user stories
- **Epic & Story Management**: Organized structure for epics and individual stories
- **Automated Build System**: Makefile-based automation for all build tasks
- **Site Packaging**: Create timestamped zip archives for distribution
- **Local Preview**: Built-in web server for local site preview

## Project Structure

```
Kurrier/
├── docs/                      # Documentation files
│   ├── Brief/                 # Project briefs
│   ├── Planning/              # Planning documents
│   ├── Reference/             # Reference materials
│   ├── resume/                # Resume-related content
│   └── site-code/             # Site generation code/templates
│
├── UserStories/               # User stories and epics (AsciiDoc source)
│   ├── Epics/                 # Epic-level user stories
│   ├── Stories/               # Individual user stories (generated)
│   ├── Templates/             # Story templates
│   ├── index.adoc             # Main index
│   ├── Demo_Golden_Path.adoc
│   ├── Story_Dependencies.adoc
│   └── Story_Prioritization_Summary.adoc
│
├── site/                      # Generated static website (excluded from git)
│   ├── epics/                 # Epic pages
│   ├── stories/               # Story pages
│   ├── assets/                # CSS, images, etc.
│   └── index.html             # Site homepage
│
├── site-zipped/               # Packaged site archives
│   └── kurrier-site_YYMMDD-HHMM.zip  # Timestamped site packages
│
├── makefiles/                 # Makefile includes
│   └── common.mk              # Common make rules
│
├── generate_site.rb           # Ruby site generator script
├── Makefile                   # Main build automation
├── .env                       # Environment configuration (excluded from git)
└── .gitignore                 # Git ignore rules
```

## Prerequisites

### Required Tools

- **Ruby**: For site generation script
- **asciidoctor**: For converting AsciiDoc to HTML/PDF
- **Python 3**: For local web server (optional)
- **zip**: For packaging (usually pre-installed)

### Installation

**On Arch Linux:**
```bash
sudo pacman -S ruby asciidoctor python
```

**On Debian/Ubuntu:**
```bash
sudo apt install ruby asciidoctor python3
```

**Using RubyGems (cross-platform):**
```bash
gem install asciidoctor asciidoctor-pdf
```

## Quick Start

### Verify Tools Installation
```bash
make check-tools
```

### Generate Everything
```bash
make all
```
This generates HTML, PDF files, and the static site.

### Generate and Preview Site Locally
```bash
make serve
```
Opens a web server at http://localhost:8000

### Package Site for Distribution
```bash
make package
```
Creates a timestamped zip file in `site-zipped/` directory.

## Available Make Targets

| Target | Description |
|--------|-------------|
| `make all` | Generate all HTML, PDF files, and static site (default) |
| `make html` | Generate all HTML files from .adoc sources |
| `make pdf` | Generate all PDF files from .adoc sources |
| `make html-epics` | Generate HTML files for Epics only |
| `make pdf-epics` | Generate PDF files for Epics only |
| `make site` | Generate static website in site/ directory |
| `make serve` | Generate site and start local web server on port 8000 |
| `make package` | Create timestamped zip in site-zipped/ |
| `make clean` | Remove all generated files (HTML, PDF, site) |
| `make clean-html` | Remove all generated HTML files |
| `make clean-pdf` | Remove all generated PDF files |
| `make clean-site` | Remove site directory |
| `make rebuild` | Clean and rebuild all files |
| `make list-files` | List all source .adoc files to be processed |
| `make help` | Show help message |

## Workflow Examples

### Creating a New User Story
1. Create a new `.adoc` file in `UserStories/Epics/`
2. Follow the template structure
3. Run `make all` to generate outputs
4. Preview with `make serve`

### Updating Documentation
1. Edit relevant `.adoc` files
2. Run `make rebuild` to clean and regenerate
3. Check outputs in `site/` directory

### Creating a Distributable Package
```bash
make package
```
This creates a timestamped zip file like `kurrier-site_251102-1933.zip` in the `site-zipped/` folder. This archive contains the complete static website and can be:
- Shared with stakeholders
- Deployed to any web server
- Archived for version control
- Extracted and opened locally in any browser

## Configuration

### Environment Variables

Configuration is stored in `.env` file (not committed to git). See `.env` for available settings including:
- AI/LLM provider configurations (OpenAI, Anthropic, Google, Grok, etc.)
- Azure DevOps integration
- Processing settings
- API rate limits

### GitHub Credentials

To add GitHub integration, add to your `.env`:
```bash
# GitHub Configuration
GITHUB_TOKEN=your_github_personal_access_token
GITHUB_USERNAME=your_username
GITHUB_REPO=owner/repo-name
```

## Git Workflow

### Excluded from Version Control
- `.env` - Environment configuration with secrets
- `site/` - Generated static website
- `UserStories/Stories/` - Generated story files
- `*.html`, `*.pdf` - Generated output files

### Included in Version Control
- Source `.adoc` files
- Ruby generator script
- Makefiles and build configuration
- `site-zipped/` - Packaged site archives (commented out in .gitignore)

## Troubleshooting

### "asciidoctor not found" Error
```bash
gem install asciidoctor
# or
sudo pacman -S asciidoctor
```

### Permission Denied on Scripts
```bash
chmod +x generate_site.rb
```

### Port 8000 Already in Use
```bash
# Use a different port
cd site && python3 -m http.server 8080
```

## Contributing

1. Create feature branches from `main`
2. Follow existing AsciiDoc formatting conventions
3. Test builds with `make all` before committing
4. Ensure `.env` is never committed

## License

[Add your license information here]

## Contact

[Add contact information here]

---

**Generated with Kurrier Build System**
