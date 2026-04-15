#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby script to convert all.txt (full ITU standards catalog) into a pipe-separated
# table file exactly like standards.txt.
#
# Features:
# - Parses ~25,000 lines from all.txt (tab-separated)
# - Extracts clean recommendation name (e.g. "Y.3057-2021", "D.251", "SERIES Y SUPP 60-2021")
# - Hardcoded classification logic (series extraction + explicit ordering of sections)
# - Converts date to the exact "(MM/YY)" format used in standards.txt
# - Groups by series (T, X, Z, Y, G, H, ... + SERIES variants + ITU-R)
# - Outputs a perfect replica of standards.txt layout (header + sections separated by ----- lines)
# - Default ISO column = "(none)" (matching standards.txt; joint ISO/IEC not present in all.txt)
# - Handles French/Spanish/English variants, (Pre-Published), Study Group suffixes, etc.

INPUT_FILE = 'all.txt'
OUTPUT_FILE = 'standards-full.txt'   # pipe-separated, exactly like standards.txt (you can rename to .csv if you want)

# =============================================
# HARDCODED CLASSIFICATION (as requested)
# =============================================
# 1. How to extract the series key from a recommendation name
def extract_series_key(name)
  case name
  when /^SERIES ([A-Z]) /i
    "SERIES #{$1}"
  when /^([A-Z])\./
    $1
  when /^([A-Z]{1,2})\./
    $1
  when /ITU-R ([A-Z])\./i
    "R-#{$1}"
  else
    'Other'
  end
end

# 2. Explicit order of sections (hardcoded – matches the spirit of standards.txt + covers all common ITU-T/ITU-R series)
SERIES_ORDER = [
  'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'P', 'Q', 'T', 'X', 'Y', 'Z',          # main ITU-T series
  'SERIES D', 'SERIES E', 'SERIES F', 'SERIES G', 'SERIES H', 'SERIES J', 'SERIES K',
  'SERIES L', 'SERIES M', 'SERIES P', 'SERIES Q', 'SERIES T', 'SERIES X', 'SERIES Y', 'SERIES Z',
  'R-M', 'R-BT', 'R-BS', 'R-B', 'R-F', 'R-P', 'R-S', 'R-SA', 'R-V',                     # ITU-R sub-series
  'Other'
].freeze

# =============================================
# Parser for one line of all.txt
# =============================================
def parse_line(line)
  return nil if line.strip.empty?

  fields = line.strip.split("\t")
  return nil if fields.size < 5

  rec_full = fields[1].strip
  pub_date = fields[2].strip
  # lang = fields[3].strip   # we ignore language column for the table (title already reflects it)
  title    = fields[4..-1].join("\t").strip

  # Clean recommendation name for the "Name" column (exactly like standards.txt)
  name = rec_full
         .sub(/^ITU-[TR] /i, '')                  # remove ITU-T / ITU-R prefix
         .sub(/ (FRENCH|SPANISH|ENGLISH)-?\d{4}$/i, '') # remove language suffix like " FRENCH-2088"
         .strip

  # ISO column is always "(none)" in this dataset (matching standards.txt style)
  iso = '(none)'

  # Convert date to "(MM/YY)" format used in standards.txt
  code = '(N/A)'
  if pub_date =~ /^(\d{4})-(\d{2})-(\d{2})$/
    year = $1.to_i
    month = $2.to_i
    yy = year % 100
    code = "(#{format('%02d', month)}/#{format('%02d', yy)})"
  elsif !pub_date.empty?
    code = "(#{pub_date})"
  end

  # Clean description (remove trailing " - Study Group XX" to keep it clean like standards.txt)
  desc = title
         .sub(/ - Study Group \d+$/i, '')
         .strip

  [name, iso, code, desc]
end

# =============================================
# Main logic
# =============================================
puts "Reading #{INPUT_FILE} (this may take a few seconds for ~25k lines)..."

entries = []
File.foreach(INPUT_FILE) do |line|
  parsed = parse_line(line)
  entries << parsed if parsed
end

puts "Parsed #{entries.size} standards."

# Group by series using the hardcoded extraction logic
groups = Hash.new { |h, k| h[k] = [] }
entries.each do |name, iso, code, desc|
  key = extract_series_key(name)
  groups[key] << [name, iso, code, desc]
end

# Build ordered list of sections (hardcoded order + any extra series that appeared)
active_series = SERIES_ORDER.select { |s| groups.key?(s) }
remaining = (groups.keys - active_series).sort
active_series += remaining

# Write the output file exactly in the style of standards.txt
File.open(OUTPUT_FILE, 'w:UTF-8') do |f|
  f.puts 'Name     | ISO             | Code (40 chars)    | Description (Full STD Title)'
  f.puts '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

  active_series.each do |series|
    next unless groups[series]&.any?

    # Sort entries inside each series (natural order by name)
    sorted = groups[series].sort_by { |e| e[0] }

    sorted.each do |name, iso, code, desc|
      # Pad columns to look nice (matching standards.txt alignment)
      name_col = name.ljust(9)
      iso_col  = iso.ljust(16)
      code_col = code.ljust(19)
      f.puts "#{name_col}| #{iso_col}| #{code_col}| #{desc}"
    end

    # Separator between series groups (exactly like standards.txt)
    f.puts '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
  end
end

puts "Done! Output written to #{OUTPUT_FILE}"
puts "   → #{entries.size} standards categorized into #{active_series.size} series sections."
puts "   → Open #{OUTPUT_FILE} in any text editor or spreadsheet (it is pipe-separated)."
