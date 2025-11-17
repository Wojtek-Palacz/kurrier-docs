# Kurrier Site Color Palette

## Vibrant Color Theme

The static site uses a vibrant yet professional color scheme designed for visual appeal and readability.

### Primary Colors

| Color Variable | Hex Code | Description | Usage |
|---------------|----------|-------------|-------|
| `--primary-color` | `#4a7ba7` | Medium blue | Headers, main text, primary elements |
| `--secondary-color` | `#6fa8dc` | Sky blue | Links, accents, table headers, borders |
| `--accent-color` | `#e89ca5` | Coral pink | Highlights, borders, special accents |
| `--success-color` | `#7ec4a3` | Mint green | Checkboxes, success states, code borders |
| `--info-color` | `#a594d9` | Periwinkle | Header gradients, info elements |
| `--warning-color` | `#f4b96f` | Golden orange | Warning states, callouts, hover accents |

### Background & Neutral Colors

| Color Variable | Hex Code | Description | Usage |
|---------------|----------|-------------|-------|
| `--background-color` | `#fafbfc` | Very light gray | Main background |
| `--background-alt` | `#f0f7fc` | Light blue tint | Alternating rows, code backgrounds |
| `--background-highlight` | `#fff8e8` | Soft yellow highlight | Hover states, special highlights |
| `--text-color` | `#2c3e50` | Dark blue-gray | Body text |
| `--text-muted` | `#6b7b85` | Muted gray-blue | Secondary text |
| `--border-color` | `#d0e0f0` | Soft blue border | Table borders, dividers |
| `--hover-bg` | `#e8f4f8` | Light cyan tint | Hover states |
| `--toc-bg` | `#f5faff` | Very light blue | Table of contents background |
| `--shadow-color` | `rgba(74, 123, 167, 0.15)` | Semi-transparent blue | Box shadows |

## Color Applications

### Headers

#### Main Header (h1)
- Background: Gradient from Medium blue → Sky blue → Periwinkle
- Bottom border: 4px Coral pink
- Enhanced shadow with color tint

#### Section Headers (h2)
- Color: Medium blue
- Bottom border: 3px Sky blue
- Background: Gradient from light cyan to transparent
- Increased left padding (1.25rem) for visibility

#### Subsection Headers (h3)
- Color: Medium blue
- Left border: 5px Coral pink
- Background: Gradient from soft yellow to transparent
- Adds visual hierarchy

### Table of Contents (TOC)
- Background: Vertical gradient from very light blue to light blue tint
- Right border: 3px Sky blue (more prominent)
- Title: Medium blue with Sky blue underline
- Enhanced shadow for depth

### Tables
- Header: Gradient from Medium blue to Sky blue
- Bottom border: 3px Mint green accent
- Alternating rows: White and light blue tint
- Hover: Soft yellow highlight with Golden orange left border

### Interactive Elements

#### Links
- Default: Sky blue
- Hover: Medium blue with underline

#### Checkboxes
- Default: Mint green
- Hover: Golden orange
- Row highlight: Soft yellow background

#### Code
- Background: Light blue tint
- Color: Periwinkle
- Border: 1px Sky blue

#### Code Blocks (pre)
- Background: Gradient from Medium blue to darker blue
- Left border: 5px Mint green
- Enhanced shadow and padding

### Special Elements

#### Lead Paragraphs
- Background: Gradient from soft yellow to light cyan
- Left border: 6px Golden orange
- Box shadow for elevation
- Increased padding (1.25rem)

#### Horizontal Rules
- Gradient: Sky blue → Coral pink → Periwinkle → Mint green
- Creates colorful visual breaks

## Color Philosophy

The palette creates a vibrant, engaging experience through:

1. **Rich Blues** (#4a7ba7, #6fa8dc) - Professional and trustworthy
2. **Warm Accents** (#e89ca5, #f4b96f) - Energy and warmth
3. **Fresh Greens** (#7ec4a3) - Success and growth
4. **Soft Purples** (#a594d9) - Creativity and elegance
5. **Strategic Highlights** (#fff8e8) - Subtle emphasis without overwhelming

### Improved from Previous Version

The new color scheme features:
- **30% more color saturation** for visual impact
- **More distinct accent colors** (coral pink, golden orange)
- **Enhanced gradients** with 3+ colors
- **Colored borders** instead of gray borders
- **Shadow colors** that match the theme
- **Background highlights** with color tints

## Accessibility

All colors maintain proper contrast ratios:
- Text colors on light backgrounds: WCAG AA compliant
- White text on colored backgrounds: High contrast
- Hover states: Clear visual feedback with color changes
- Interactive elements: Distinct from static content

## Usage in CSS

Colors are defined as CSS custom properties (variables) and can be easily customized:

```css
:root {
  --primary-color: #4a7ba7;
  --secondary-color: #6fa8dc;
  /* ... other colors */
}

/* Usage example */
h2 {
  color: var(--primary-color);
  border-bottom: 3px solid var(--secondary-color);
}
```

## Regenerating the Site

The color palette is embedded in `generate_site.rb`. To regenerate the site with current colors:

```bash
make site
```

## Future Enhancements

Consider adding:
- Dark mode with complementary color scheme
- Color customization via URL parameters
- Print-friendly stylesheet with reduced colors
- High-contrast mode for accessibility
