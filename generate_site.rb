#!/usr/bin/env ruby
# frozen_string_literal: true

# Kurrier Static Site Generator
# Generates a static HTML site from AsciiDoc user stories
# No external dependencies beyond asciidoctor gem

require 'asciidoctor'
require 'fileutils'
require 'json'

class KurrierSiteGenerator
  SITE_DIR = 'site'
  EPICS_DIR = 'UserStories/Epics'
  STORIES_DIR = 'UserStories/Stories'
  ASSETS_DIR = "#{SITE_DIR}/assets"
  CSS_DIR = "#{ASSETS_DIR}/css"

  def initialize
    @epics = []
    @stories = []
  end

  def generate
    puts "Kurrier Static Site Generator"
    puts "=" * 50

    clean_site_directory
    create_directory_structure
    copy_css_assets
    scan_epics
    extract_and_generate_stories
    generate_epic_pages
    generate_index_page

    puts "\n✓ Site generated successfully in #{SITE_DIR}/"
    puts "  Open #{SITE_DIR}/index.html in your browser"
  end

  private

  def clean_site_directory
    puts "\n1. Cleaning site directory..."
    FileUtils.rm_rf(SITE_DIR) if Dir.exist?(SITE_DIR)
  end

  def create_directory_structure
    puts "2. Creating directory structure..."
    FileUtils.mkdir_p(SITE_DIR)
    FileUtils.mkdir_p("#{SITE_DIR}/epics")
    FileUtils.mkdir_p("#{SITE_DIR}/stories")
    FileUtils.mkdir_p(STORIES_DIR)
    FileUtils.mkdir_p(CSS_DIR)
  end

  def copy_css_assets
    puts "3. Generating CSS assets..."
    css_content = generate_css
    File.write("#{CSS_DIR}/kurrier.css", css_content)
  end

  def scan_epics
    puts "4. Scanning Epic files..."

    # Natural sort by extracting epic number (E1, E2, ... E10)
    epic_files = Dir.glob("#{EPICS_DIR}/Epic_*.adoc").sort_by do |file|
      basename = File.basename(file, '.adoc')
      if basename =~ /Epic_E(\d+)/
        $1.to_i  # Convert to integer for natural numeric sorting
      else
        0
      end
    end

    epic_files.each do |file|
      epic_data = extract_epic_metadata(file)
      @epics << epic_data
      puts "   Found: #{epic_data[:id]} - #{epic_data[:title]}"
    end

    puts "   Total: #{@epics.size} epics"
  end

  def extract_epic_metadata(file)
    content = File.read(file)

    # Extract title (first line starting with =)
    title = content.match(/^=\s+(.+)$/)[1] rescue File.basename(file, '.adoc')

    # Extract Epic ID
    epic_id = content.match(/\*\*Epic ID:\*\*\s+(\w+)/)[1] rescue ''

    # Extract Priority
    priority = content.match(/\*\*Priority:\*\*\s+([^\n]+)/)[1] rescue 'Unknown'

    # Extract Story Count
    story_count = content.match(/\*\*Story Count:\*\*\s+([^\n]+)/)[1] rescue '0'

    # Extract Epic Goal
    goal = ''
    if content =~ /\*\*Epic Goal:\*\*\s*\n\s*\n(.+?)(?=\n\*\*|\n\n===|\Z)/m
      goal = $1.strip.gsub(/\n+/, ' ').slice(0, 200)
    end

    actor = begin
      content.match(/\*\*Actor:\*\*\s+(\w+)/)[1]
    rescue
      'Unknown'
    end

    {
      file: file,
      basename: File.basename(file, '.adoc'),
      title: title,
      id: epic_id,
      priority: priority,
      story_count: story_count,
      goal: goal,
      actor: actor,
      content: content
    }
  end

  def extract_and_generate_stories
    puts "4.5. Extracting and generating individual story pages..."

    @epics.each do |epic|
      content = epic[:content]

      # Extract the Stories section
      if content =~ /^== Stories\s*\n\s*\n(.+?)(?=^== |\Z)/m
        stories_section = $1

        # Split by story headers (=== Story ...)
        story_blocks = stories_section.split(/(?=^=== Story )/)

        story_blocks.each do |story_block|
          next if story_block.strip.empty?

          # Extract story metadata
          story_id_raw = story_block.match(/\*\*Story ID:\*\*\s+([^\n]+)/)[1] rescue next
          story_id = story_id_raw.strip.gsub(/\s*\+\s*$/, '')  # Remove trailing + (line break)
          story_title = story_block.match(/^=== Story [^:]+:\s*(.+)$/)[1].strip rescue story_id

          # Remove the story heading from content since we'll use it as doc title
          content_without_heading = story_block.sub(/^=== Story [^\n]+\n\n/, '')

          # Create story data
          story_data = {
            id: story_id,
            title: story_title,
            epic_id: epic[:id],
            epic_title: epic[:title],
            epic_basename: epic[:basename],
            content: content_without_heading.strip
          }

          @stories << story_data

          # Generate story .adoc file
          generate_story_file(story_data)
        end
      end
    end

    puts "   Total: #{@stories.size} stories extracted"
  end

  def generate_story_file(story)
    # Create story filename (keep hyphens, replace other special chars)
    story_filename = "#{story[:id].gsub(/[^A-Za-z0-9\-]/, '-')}.adoc"
    story_file_path = "#{STORIES_DIR}/#{story_filename}"

    # Parse the story content to extract structured sections
    content = story[:content]

    # Extract various sections using regex
    story_details = extract_section_until(content, /\*\*Story ID:\*\*/, /\*\*User Story:\*\*/)
    user_story = extract_section_until(content, /\*\*User Story:\*\*/, /\*\*Acceptance Criteria:\*\*/)
    acceptance_criteria = extract_section_until(content, /\*\*Acceptance Criteria:\*\*/, /\*\*Notes:\*\*/)
    notes = extract_section_until(content, /\*\*Notes:\*\*/, /\*\*Demo Notes:\*\*/)
    demo_notes = extract_section_after(content, /\*\*Demo Notes:\*\*/)

    # Generate story .adoc content with breadcrumb navigation and proper sections
    story_adoc = <<~ADOC
= Story #{story[:id]}: #{story[:title]}
:toc: left
:toclevels: 2
:doctype: article
:icons: font
:source-highlighter: rouge
:reproducible:

++++
<div class="page-type-story" style="background: linear-gradient(135deg, #2d5f3f 0%, #4a8c5e 100%); color: white; padding: 14px 28px; margin-bottom: 20px; box-shadow: 0 3px 10px rgba(45, 95, 63, 0.3); border-bottom: 3px solid #7ec4a3; position: relative;">
  <span style="position: absolute; top: 8px; right: 16px; background: rgba(255,255,255,0.25); padding: 4px 12px; border-radius: 12px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.5px;">STORY</span>
  <nav style="font-size: 0.95rem;">
    <a href="../index.html" style="color: #ffffff; text-decoration: none; font-weight: 500; transition: all 0.2s;">🏠 Home</a>
    <span style="margin: 0 8px; opacity: 0.7;">›</span>
    <a href="../epics/#{story[:epic_basename]}.html" style="color: #ffffff; text-decoration: none; font-weight: 500; transition: all 0.2s;">#{story[:epic_id]}: #{story[:epic_title].sub(/^Epic \w+:\s*/, '')}</a>
    <span style="margin: 0 8px; opacity: 0.7;">›</span>
    <span style="opacity: 0.9;">#{story[:id]}</span>
  </nav>
</div>
++++

== Story Details

#{story_details}

== User Story

#{user_story}

== Acceptance Criteria

#{acceptance_criteria}

== Notes

#{notes}

== Demo Notes

#{demo_notes}

---

++++
<div style="margin-top: 2rem; padding: 1rem; background: #f0f7fc; border-left: 4px solid #4a7ba7; border-radius: 4px;">
  <a href="../epics/#{story[:epic_basename]}.html" style="color: #4a7ba7; text-decoration: none; font-weight: 600;">← Back to #{story[:epic_id]}: #{story[:epic_title].sub(/^Epic \w+:\s*/, '')}</a>
</div>
++++
    ADOC

    # Write story .adoc file
    File.write(story_file_path, story_adoc)

    # Convert to HTML
    output_file = "#{SITE_DIR}/stories/#{story[:id].gsub(/[^A-Za-z0-9\-]/, '-')}.html"

    Asciidoctor.convert_file(
      story_file_path,
      to_file: output_file,
      safe: :unsafe,
      attributes: {
        'stylesheet' => '../assets/css/kurrier.css',
        'linkcss' => true,
        'toc' => 'left',
        'toclevels' => 3,
        'icons' => 'font',
        'source-highlighter' => 'rouge',
        'reproducible' => ''
      }
    )

    # Fix stylesheet paths in generated HTML
    fix_stylesheet_paths(output_file)

    # Move breadcrumbs to correct position (before header)
    fix_story_breadcrumbs(output_file)

    puts "   Generated: #{story[:id]}.html"
  end

  def extract_section_until(content, start_pattern, end_pattern)
    # Extract content from start_pattern up to (but not including) end_pattern
    if content =~ /#{start_pattern}(.+?)#{end_pattern}/m
      return fix_numbered_lists($1.strip)
    end
    ""
  end

  def extract_section_after(content, start_pattern)
    # Extract everything after start_pattern
    if content =~ /#{start_pattern}(.+)/m
      return fix_numbered_lists($1.strip)
    end
    ""
  end

  def fix_numbered_lists(text)
    # Add blank line before numbered lists for proper AsciiDoc rendering
    # Pattern: line ending with : or text, immediately followed by "1. " on next line
    text = text.gsub(/([^\n])\n(\d+\.\s)/, "\\1\n\n\\2")
    # Also fix asterisk lists
    fix_asterisk_lists(text)
  end

  def fix_asterisk_lists(text)
    # Add blank line before asterisk lists for proper AsciiDoc rendering
    # Pattern: line ending with text (especially **), immediately followed by "* " on next line
    text.gsub(/([^\n])\n(\*\s)/, "\\1\n\n\\2")
  end

  def fix_story_breadcrumbs(html_file)
    content = File.read(html_file)

    # Extract just the breadcrumb navigation div (with nested nav and closing div)
    breadcrumb_pattern = /(<div style="background: linear-gradient\(135deg, #4a7ba7.*?<\/nav>\s*<\/div>)/m
    breadcrumb_match = content.match(breadcrumb_pattern)

    if breadcrumb_match
      breadcrumb_html = breadcrumb_match[1]

      # Remove it from where it currently is (inside #content)
      content.sub!(breadcrumb_html, '')

      # Insert it right after <body> tag, before #header
      content.sub!(/<body[^>]*>\n/, "\\0#{breadcrumb_html}\n\n")

      File.write(html_file, content)
    end
  end

  def generate_epic_pages
    puts "5. Generating Epic HTML pages..."

    @epics.each do |epic|
      # Create a modified epic with story links instead of full content
      modified_epic_content = create_epic_with_story_links(epic)

      # Write modified epic to temporary file
      temp_epic_file = "#{EPICS_DIR}/.temp_#{epic[:basename]}.adoc"
      File.write(temp_epic_file, modified_epic_content)

      output_file = "#{SITE_DIR}/epics/#{epic[:basename]}.html"

      Asciidoctor.convert_file(
        temp_epic_file,
        to_file: output_file,
        safe: :unsafe,
        attributes: {
          'stylesheet' => '../assets/css/kurrier.css',
          'linkcss' => true,
          'toc' => 'left',
          'toclevels' => 3,
          'icons' => 'font',
          'source-highlighter' => 'rouge',
          'reproducible' => ''
        }
      )

      # Clean up temporary file
      FileUtils.rm_f(temp_epic_file)

      # Fix stylesheet paths and add navigation
      fix_stylesheet_paths(output_file)
      add_navigation_to_html(output_file, epic)

      puts "   Generated: #{epic[:basename]}.html"
    end
  end

  def create_epic_with_story_links(epic)
    content = epic[:content]

    # Find the Stories section
    if content =~ /^== Stories\s*\n\s*\n(.+?)(?=^== |\Z)/m
      stories_section = $1
      stories_start = content.index("== Stories")

      # Get content before Stories section
      before_stories = fix_numbered_lists(content[0...stories_start])

      # Get content after Stories section (Epic Summary, etc.)
      after_stories = fix_numbered_lists(content.match(/^== Epic Summary.+/m).to_s)

      # Generate story links section
      epic_stories = @stories.select { |s| s[:epic_id] == epic[:id] }

      story_links_section = "== Stories\n\n"
      story_links_section += "This epic contains #{epic_stories.size} user stories. Click on any story to view its details.\n\n"

      epic_stories.each_with_index do |story, index|
        story_filename = "#{story[:id].gsub(/[^A-Za-z0-9\-]/, '-')}.html"
        story_links_section += "=== link:../stories/#{story_filename}[#{story[:id]}: #{story[:title]}]\n\n"

        # Extract basic info for preview
        if story[:content] =~ /\*\*Priority:\*\*\s+([^\n]+)/
          priority = $1.strip
          story_links_section += "**Priority:** #{priority}\n\n"
        end

        story_links_section += "Click to view full story details, acceptance criteria, and implementation notes.\n\n"
        story_links_section += "'''\n\n" unless index == epic_stories.size - 1
      end

      # Combine all sections
      "#{before_stories}#{story_links_section}\n#{after_stories}"
    else
      # If no Stories section found, return original content
      fix_numbered_lists(content)
    end
  end

  def fix_stylesheet_paths(html_file)
    content = File.read(html_file)

    # Fix stylesheet paths - remove ./ and ./../ prefixes that can cause browser issues
    content.gsub!('href="./../assets/css/kurrier.css"', 'href="../assets/css/kurrier.css"')
    content.gsub!('href="./assets/css/kurrier.css"', 'href="assets/css/kurrier.css"')

    File.write(html_file, content)
  end

  def add_navigation_to_html(html_file, epic = nil)
    content = File.read(html_file)

    # Create breadcrumb navigation for epic pages
    if epic
      epic_title = epic[:title].sub(/^Epic \w+:\s*/, '')
      nav_html = <<~HTML
        <div class="page-type-epic" style="background: linear-gradient(135deg, #5d4a7b 0%, #8b6fa8 100%); color: white; padding: 14px 28px; margin-bottom: 20px; box-shadow: 0 3px 10px rgba(93, 74, 123, 0.3); border-bottom: 3px solid #a594d9; position: relative;">
          <span style="position: absolute; top: 8px; right: 16px; background: rgba(255,255,255,0.25); padding: 4px 12px; border-radius: 12px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.5px;">EPIC</span>
          <nav style="font-size: 0.95rem;">
            <a href="../index.html" style="color: #ffffff; text-decoration: none; font-weight: 500; transition: all 0.2s;">🏠 Home</a>
            <span style="margin: 0 8px; opacity: 0.7;">›</span>
            <span style="opacity: 0.9;">#{epic[:id]}: #{epic_title}</span>
          </nav>
        </div>
      HTML
    else
      # Default "Back to Epic Overview" for backward compatibility
      nav_html = <<~HTML
        <div style="background: linear-gradient(135deg, #4a7ba7 0%, #6fa8dc 100%); color: white; padding: 14px 28px; margin-bottom: 20px; box-shadow: 0 3px 10px rgba(74, 123, 167, 0.2); border-bottom: 3px solid #e89ca5;">
          <a href="../index.html" style="color: #ffffff; text-decoration: none; font-weight: 600; transition: all 0.2s; display: inline-block;">← Back to Epic Overview</a>
        </div>
      HTML
    end

    content.sub!(/<body[^>]*>/, "\\0\n#{nav_html}")
    File.write(html_file, content)
  end

  def generate_index_page
    puts "6. Generating index page..."

    index_adoc = generate_index_adoc
    File.write('UserStories/index.adoc', index_adoc)

    Asciidoctor.convert_file(
      'UserStories/index.adoc',
      to_file: "#{SITE_DIR}/index.html",
      safe: :unsafe,
      attributes: {
        'stylesheet' => 'assets/css/kurrier.css',
        'linkcss' => true,
        'toc' => 'left',
        'toclevels' => 2,
        'icons' => 'font',
        'source-highlighter' => 'rouge',
        'reproducible' => ''
      }
    )

    # Fix stylesheet paths in index page
    fix_stylesheet_paths("#{SITE_DIR}/index.html")

    puts "   Generated: index.html"
  end

  def generate_index_adoc
    consumer_epics = @epics.select { |e| e[:actor] == 'Consumer' }
    driver_epics = @epics.select { |e| e[:actor] == 'Driver' }

    <<~ADOC
= Kurrier User Stories - Epic Overview
:toc: left
:toclevels: 2
:doctype: article
:icons: font
:source-highlighter: rouge
:reproducible:

[.lead]
*Kurrier Inc.* - Last-Mile Parcel Pickup Platform

This documentation provides comprehensive user stories organized into epics for the Kurrier platform, a mobile app connecting consumers who need parcel shipping with gig-economy drivers who provide last-mile pickup to carrier hubs.

== Project Overview

**Project:** Kurrier Inc. Mobile Application +
**Purpose:** Last-mile parcel pickup platform +
**Target Users:** Consumers (shippers) and Drivers (gig workers) +
**Key Differentiator:** On-demand pickup with real-time tracking and competitive carrier quotes

== Epic Structure

The Kurrier platform is organized into #{@epics.size} major epics, split between Consumer and Driver experiences.

=== Consumer Epics (E1-E6)

[cols="1,3,2,1", options="header"]
|===
|Epic ID|Epic Name|Priority|Stories

#{consumer_epics.map { |e|
  "|link:epics/#{e[:basename]}.html[#{e[:id]}]\n|#{e[:title].sub(/^Epic \w+:\s*/, '')}\n|#{e[:priority]}\n|#{e[:story_count]}"
}.join("\n\n")}

|===

=== Driver Epics (E7-E10)

[cols="1,3,2,1", options="header"]
|===
|Epic ID|Epic Name|Priority|Stories

#{driver_epics.map { |e|
  "|link:epics/#{e[:basename]}.html[#{e[:id]}]\n|#{e[:title].sub(/^Epic \w+:\s*/, '')}\n|#{e[:priority]}\n|#{e[:story_count]}"
}.join("\n\n")}

|===

== Epic Summaries

#{@epics.map { |e|
  "=== #{e[:id]}: #{e[:title].sub(/^Epic \w+:\s*/, '')}\n\n" +
  "link:epics/#{e[:basename]}.html[View Full Epic →]\n\n" +
  "**Actor:** #{e[:actor]} | " +
  "**Priority:** #{e[:priority]} | " +
  "**Stories:** #{e[:story_count]}\n\n" +
  "#{e[:goal]}\n\n'''"
}.join("\n\n")}

== Priority Legend

[cols="1,3", options="header"]
|===
|Priority|Description

|**Must Have (M)**
|Core functionality required for MVP/demo

|**Should Have (S)**
|Important features that enhance value

|**Could Have pass:[(C)]**
|Nice-to-have features for future phases

|===

---

_Generated from Kurrier User Stories Master Documentation_ +
_Last Updated: #{Time.now.strftime('%Y-%m-%d')}_
    ADOC
  end

  def generate_css
    <<~CSS
/* Kurrier Documentation Theme - Subdued Pastel Palette */

:root {
  --primary-color: #4a7ba7;        /* Medium blue */
  --secondary-color: #6fa8dc;      /* Sky blue */
  --accent-color: #e89ca5;         /* Coral pink */
  --success-color: #7ec4a3;        /* Mint green */
  --info-color: #a594d9;           /* Periwinkle */
  --warning-color: #f4b96f;        /* Golden orange */
  --background-color: #fafbfc;     /* Very light gray */
  --background-alt: #f0f7fc;       /* Light blue tint */
  --background-highlight: #fff8e8; /* Soft yellow highlight */
  --text-color: #2c3e50;           /* Dark blue-gray */
  --text-muted: #6b7b85;           /* Muted gray-blue */
  --border-color: #d0e0f0;         /* Soft blue border */
  --hover-bg: #e8f4f8;             /* Light cyan tint */
  --toc-bg: #f5faff;               /* Very light blue */
  --shadow-color: rgba(74, 123, 167, 0.15);
}

body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  line-height: 1.6;
  color: var(--text-color);
  background-color: var(--background-color);
  margin: 0;
  padding: 0;
}

#header {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 50%, var(--info-color) 100%);
  color: white;
  padding: 2rem 2rem 1rem;
  box-shadow: 0 4px 12px var(--shadow-color);
  border-bottom: 4px solid var(--accent-color);
}

body.toc2 #header {
  padding-left: 360px;
  padding-right: 2rem;
}

/* Epic page specific header styling */
.page-type-epic ~ #header {
  background: linear-gradient(135deg, #5d4a7b 0%, #8b6fa8 50%, #a594d9 100%);
  border-bottom: 4px solid #a594d9;
}

/* Story page specific header styling */
.page-type-story ~ #header {
  background: linear-gradient(135deg, #2d5f3f 0%, #4a8c5e 50%, #7ec4a3 100%);
  border-bottom: 4px solid #7ec4a3;
}

/* Adjust breadcrumb navigation for TOC pages */
body.toc2 > div[style*="background: linear-gradient"] {
  margin-left: 320px !important;
}

#header h1 {
  margin: 0 0 0.5rem 0;
  font-size: 2.5rem;
  font-weight: 700;
}

#header .details {
  font-size: 1.1rem;
  opacity: 0.9;
}

#toc {
  background: linear-gradient(180deg, var(--toc-bg) 0%, var(--background-alt) 100%);
  border-right: 3px solid var(--secondary-color);
  padding: 1.5rem;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: 280px;
  overflow-y: auto;
  box-shadow: 4px 0 12px var(--shadow-color);
}

#toctitle {
  color: var(--primary-color);
  font-weight: 600;
  font-size: 1.1rem;
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid var(--secondary-color);
}

#toc ul {
  list-style: none;
  padding-left: 0;
}

#toc li {
  margin: 0.5rem 0;
}

#toc a {
  color: var(--text-color);
  text-decoration: none;
  transition: color 0.2s;
}

#toc a:hover {
  color: var(--secondary-color);
}

#content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  background: white;
  box-shadow: 0 0 10px rgba(0,0,0,0.05);
}

body.toc2 #content {
  margin-left: 360px;
  margin-right: 2rem;
  max-width: calc(100% - 400px);
}

h2 {
  color: var(--primary-color);
  border-bottom: 3px solid var(--secondary-color);
  padding-bottom: 0.5rem;
  margin-top: 2rem;
  background: linear-gradient(to right, var(--hover-bg) 0%, transparent 100%);
  padding-left: 1.25rem;
  padding-right: 1rem;
  border-radius: 2px;
}

h3 {
  color: var(--primary-color);
  margin-top: 1.5rem;
  border-left: 5px solid var(--accent-color);
  padding-left: 0.75rem;
  margin-left: 0.25rem;
  background: linear-gradient(to right, var(--background-highlight) 0%, transparent 30%);
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
}

/* Epic page accent colors */
.page-type-epic ~ #header ~ #content h2 {
  color: #5d4a7b;
  border-bottom: 3px solid #8b6fa8;
}

.page-type-epic ~ #header ~ #content h3 {
  color: #5d4a7b;
  border-left: 5px solid #a594d9;
}

/* Story page accent colors */
.page-type-story ~ #header ~ #content h2 {
  color: #2d5f3f;
  border-bottom: 3px solid #4a8c5e;
}

.page-type-story ~ #header ~ #content h3 {
  color: #2d5f3f;
  border-left: 5px solid #7ec4a3;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

th {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
  color: white;
  padding: 0.875rem 0.75rem;
  text-align: left;
  font-weight: 600;
  border-bottom: 3px solid var(--success-color);
}

td {
  padding: 0.75rem;
  border-bottom: 1px solid var(--border-color);
}

tbody tr:nth-child(odd) {
  background-color: white;
}

tbody tr:nth-child(even) {
  background-color: var(--background-alt);
}

tbody tr:hover {
  background-color: var(--background-highlight);
  transition: background-color 0.2s ease;
  border-left: 4px solid var(--warning-color);
}

a {
  color: var(--secondary-color);
  text-decoration: none;
  transition: color 0.2s;
}

a:hover {
  color: var(--primary-color);
  text-decoration: underline;
}

.lead {
  font-size: 1.3rem;
  color: var(--primary-color);
  font-weight: 500;
  margin-bottom: 2rem;
  padding: 1.25rem;
  background: linear-gradient(135deg, var(--background-highlight) 0%, var(--hover-bg) 100%);
  border-left: 6px solid var(--warning-color);
  border-radius: 4px;
  box-shadow: 0 2px 8px var(--shadow-color);
}

code {
  background: var(--background-alt);
  color: var(--info-color);
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-family: "Monaco", "Courier New", monospace;
  font-size: 0.9em;
  border: 1px solid var(--secondary-color);
  font-weight: 500;
}

pre {
  background: linear-gradient(135deg, var(--primary-color) 0%, #3a5f7d 100%);
  color: #ecf0f1;
  padding: 1.25rem;
  border-radius: 6px;
  overflow-x: auto;
  border-left: 5px solid var(--success-color);
  box-shadow: 0 4px 12px var(--shadow-color);
}

.ulist ul {
  list-style-type: disc;
  padding-left: 1.5rem;
}

.ulist ul ul {
  list-style-type: circle;
}

.checklist ul {
  list-style: none;
  padding-left: 0;
}

.checklist li {
  padding: 0;
  margin: 0;
  line-height: 1.15;
}

/* Style the Font Awesome checkbox icons that AsciiDoc generates */
.checklist li .fa-square-o {
  color: var(--success-color);
  margin-right: 0.5rem;
  font-size: 1.1em;
}

.checklist li:hover {
  background: var(--background-highlight);
  margin-left: -0.5rem;
  padding-left: 0.5rem;
  border-radius: 4px;
}

.checklist li:hover .fa-square-o {
  color: var(--warning-color);
}

hr {
  border: none;
  border-top: 2px solid var(--border-color);
  margin: 2rem 0;
  background: linear-gradient(to right, var(--secondary-color), var(--accent-color), var(--info-color), var(--success-color));
  height: 2px;
}

/* Responsive */
@media (max-width: 768px) {
  #toc {
    position: static;
    width: 100%;
    border-right: none;
    border-bottom: 1px solid var(--border-color);
  }

  body.toc2 #content {
    margin-left: 0;
  }
}
    CSS
  end
end

# Run the generator
if __FILE__ == $PROGRAM_NAME
  begin
    generator = KurrierSiteGenerator.new
    generator.generate
  rescue => e
    puts "\n✗ Error: #{e.message}"
    puts e.backtrace
    exit 1
  end
end
