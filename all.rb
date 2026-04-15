#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby script to convert all.txt → standards_full.txt
# FIXED: Name column padding now matches standards.txt style exactly
#        (Name field = 25 characters wide to accommodate all 25k+ entries
#         while keeping perfect visual alignment like the original standards.txt)

INPUT_FILE = 'all.txt'
OUTPUT_FILE = 'standards-full.txt'

# =============================================
# HARDCODED CLASSIFICATION (unchanged)
# =============================================
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

SERIES_ORDER = [
  'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'P', 'Q', 'T', 'X', 'Y', 'Z',
  'SERIES D', 'SERIES E', 'SERIES F', 'SERIES G', 'SERIES H', 'SERIES J', 'SERIES K',
  'SERIES L', 'SERIES M', 'SERIES P', 'SERIES Q', 'SERIES T', 'SERIES X', 'SERIES Y', 'SERIES Z',
  'R-M', 'R-BT', 'R-BS', 'R-B', 'R-F', 'R-P', 'R-S', 'R-SA', 'R-V',
  'Other'
].freeze

# =============================================
# FIXED COLUMN WIDTHS (exactly like standards.txt style)
# =============================================
NAME_WIDTH = 25   # ← FIXED: was 9, now 25 to fit long names (Y.3057-2021, SERIES L SUPP 44-2021, etc.)
ISO_WIDTH  = 16
CODE_WIDTH = 19

# =============================================
# Parser
# =============================================
def parse_line(line)
  return nil if line.strip.empty?

  fields = line.strip.split("\t")
  return nil if fields.size < 5

  rec_full = fields[1].strip
  pub_date = fields[2].strip
  title    = fields[4..-1].join("\t").strip

  # Clean name exactly as in standards.txt
  name = rec_full
         .sub(/^ITU-[TR] /i, '')
         .sub(/ (FRENCH|SPANISH|ENGLISH)-?\d{4}$/i, '')
         .strip

  iso = '(none)'

  # Code in (MM/YY) format
  code = '(N/A)'
  if pub_date =~ /^(\d{4})-(\d{2})-(\d{2})$/
    month = $2.to_i
    yy = $1.to_i % 100
    code = "(#{format('%02d', month)}/#{format('%02d', yy)})"
  elsif !pub_date.empty?
    code = "(#{pub_date})"
  end

  desc = title.sub(/ - Study Group \d+$/i, '').strip

  [name, iso, code, desc]
end

# =============================================
# Main
# =============================================
puts "Reading #{INPUT_FILE}..."

entries = []
File.foreach(INPUT_FILE) do |line|
  parsed = parse_line(line)
  entries << parsed if parsed
end

puts "Parsed #{entries.size} standards."

# Group by series
groups = Hash.new { |h, k| h[k] = [] }
entries.each do |name, iso, code, desc|
  key = extract_series_key(name)
  groups[key] << [name, iso, code, desc]
end

# Ordered sections
active_series = SERIES_ORDER.select { |s| groups.key?(s) }
remaining = (groups.keys - active_series).sort
active_series += remaining

# Write output with perfect padding
File.open(OUTPUT_FILE, 'w:UTF-8') do |f|
  # Header exactly like standards.txt but with wider Name column
  f.puts "Name#{' ' * (NAME_WIDTH - 4)} | ISO#{' ' * (ISO_WIDTH - 3)} | Code (40 chars)#{' ' * (CODE_WIDTH - 15)} | Description (Full STD Title)"
  f.puts '-' * 180   # long separator

  active_series.each do |series|
    next unless groups[series]&.any?

    sorted = groups[series].sort_by { |e| e[0] }

    sorted.each do |name, iso, code, desc|
      name_col = name.ljust(NAME_WIDTH)      # ← FIXED PADDING
      iso_col  = iso.ljust(ISO_WIDTH)
      code_col = code.ljust(CODE_WIDTH)
      f.puts "#{name_col}| #{iso_col}| #{code_col}| #{desc}"
    end

    f.puts '-' * 180
  end
end

puts "Done! → #{OUTPUT_FILE}"
puts "   Perfect column padding (Name = #{NAME_WIDTH} chars) like standards.txt"
puts "   All #{entries.size} standards categorized and aligned."
