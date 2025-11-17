# Changelog

All notable changes to the Kurrier User Stories build system and static site generator.

## [2025-10-30] - Latest

### Added
- **Epic Page Breadcrumbs**: Epic pages now have breadcrumb navigation
  - Format: 🏠 Home › Epic ID: Epic Name
  - Consistent styling with story page breadcrumbs
  - Replaces previous "← Back to Epic Overview" link
  - Home icon links back to index page
  - Current epic shown as non-clickable text

- **Individual Story Pages**: Each user story now has its own dedicated page
  - 44 individual story pages generated from epic files
  - Epic pages now display story links with priority preview
  - Clean URLs (e.g., `C-E1-01.html`, `D-E7-02.html`)
  - Automatic extraction from epic Stories sections
  - Story content properly formatted without heading duplication

- **Breadcrumb Navigation**: Comprehensive navigation system for story pages
  - Format: 🏠 Home › Epic ID › Story ID
  - All links functional and styled consistently
  - Back-to-epic link at bottom of each story page
  - Navigation bar with gradient styling matching site theme
  - Works seamlessly with existing epic and index navigation

### Fixed
- **Bullet List Formatting**: Added empty lines before bullet lists in all epic files
  - AsciiDoc requires an empty line after text ending with `:` before bullet lists
  - Fixed 14 instances across epic files where lists immediately followed colons
  - Ensures proper list rendering in both .adoc source and generated HTML
  - Example: "critical for:" now has empty line before "- Driver acquisition..."
  - Script created to automatically detect and fix this pattern

- **Breadcrumb Navigation Position**: Fixed story page breadcrumbs appearing in wrong location
  - Breadcrumbs now positioned BEFORE the page header (same as epic pages)
  - Previously were inside `#content` div, now correctly placed after `<body>` tag
  - Navigation bar now visible at top of all story pages
  - Added `fix_story_breadcrumbs()` post-processing method

- **CSS Path Issues**: Fixed stylesheet paths in all generated HTML files
  - Removed `./../` and `./` prefixes that could cause loading issues in some browsers
  - Index page now uses clean `assets/css/kurrier.css` path
  - Epic and story pages use clean `../assets/css/kurrier.css` path
  - All pages now load CSS correctly when opened from extracted zip files
  - Post-processing step added to `generate_site.rb` to clean paths

- **Doubled Checkboxes**: Removed CSS-generated checkboxes that duplicated Font Awesome icons
  - Changed from `::before` pseudo-element with content to direct `.fa-square-o` styling
  - Checkboxes now appear once instead of twice
  - Maintained color styling (mint green default, golden orange on hover)

- **Epic Sorting**: Epics now sort naturally (E1, E2, ... E9, E10) instead of alphabetically
  - Implemented natural sorting by extracting numeric portion of epic IDs
  - Applies to all views: scan output, index page tables, epic summaries
  - E10 now correctly appears after E9

- **Heading Visibility**: Fixed h1 and h2 headings being cut off by the TOC sidebar
  - Increased header padding: `padding-left: 340px` (was 320px)
  - Increased h2 left padding: `1.25rem` (was 0.75rem)
  - Added right padding to both header and h2 for better spacing
  - Adjusted content margins to `340px` for proper alignment
  - Set max-width calculation to prevent content overflow

### Changed
- **Package Location**: Zip files now created in `site-zipped/` directory instead of project root
  - Updated Makefile package target
  - Updated .gitignore to exclude `site-zipped/` directory
  - All documentation updated to reflect new location

- **Color Scheme**: Updated CSS with vibrant, colorful palette (30% more saturation)
  - **Blues**: Medium blue (#4a7ba7) primary, Sky blue (#6fa8dc) accents
  - **Warm tones**: Coral pink (#e89ca5), Golden orange (#f4b96f)
  - **Fresh accents**: Mint green (#7ec4a3), Periwinkle (#a594d9)
  - **Backgrounds**: Light blue tints, soft yellow highlights
  - **Multi-color gradients**: 3+ colors in headers, TOC, and horizontal rules
  - **Colored borders**: Sky blue, coral pink, mint green instead of grays
  - **Enhanced shadows**: Blue-tinted shadows for depth
  - **Interactive highlights**: Yellow backgrounds on hover with orange borders
  - **TOC styling**: Gradient background with prominent colored border
  - **Vibrant code blocks**: Periwinkle text with sky blue borders
  - **Table enhancements**: Mint green accent on headers, yellow hover highlights

### Added
- **Static Site Generator**: Self-contained Ruby script for generating static website
  - Automatic Epic metadata extraction
  - Professional CSS theming with subdued pastels
  - Navigation links between pages
  - Comprehensive index page with all epics

- **Build System**: Makefile-based build automation
  - HTML generation from AsciiDoc sources
  - PDF generation from AsciiDoc sources
  - Static website generation (`make site`)
  - Local web server (`make serve`)
  - Timestamped zip packaging (`make package`)
  - Clean targets for all artifacts

- **Documentation**:
  - README.md - Complete project documentation
  - COLORS.md - Color palette reference
  - makefiles/README.md - Build system documentation
  - CHANGELOG.md - This file

## File Structure

```
Kurrier/
├── UserStories/
│   ├── Epics/              # Epic .adoc source files
│   ├── Stories/            # Generated story .adoc files
│   └── index.adoc          # Auto-generated index
├── site/                   # Generated static website
│   ├── index.html
│   ├── epics/*.html        # Epic pages with story links
│   ├── stories/*.html      # Individual story pages
│   └── assets/css/kurrier.css
├── site-zipped/            # Packaged zip archives
│   └── kurrier-site_*.zip
├── makefiles/              # Build system modules
├── generate_site.rb        # Static site generator
├── Makefile               # Main build file
└── docs/                   # Project documentation
```

## Usage

```bash
# Generate everything (HTML, PDF, static site)
make

# Generate just the static website
make site

# Serve locally at http://localhost:8000
make serve

# Package for distribution
make package

# Clean all generated files
make clean
```

## Technical Notes

- **AsciiDoc Processing**: Uses asciidoctor gem (Ruby)
- **PDF Generation**: Uses asciidoctor-pdf gem
- **Site Generation**: Pure Ruby, no external dependencies
- **Styling**: CSS3 with CSS variables for theming
- **Responsive**: Mobile-friendly design with media queries

## Known Issues

None currently.

## Future Enhancements

- Consider adding dark mode toggle
- Add search functionality to static site
- Generate navigation breadcrumbs
- Add export to other formats (Markdown, DocBook)
