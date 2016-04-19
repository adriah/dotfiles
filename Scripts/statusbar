#!/bin/bash
#
# ~/Scripts/statusbar
#
# Status bar for dwm. Expanded from:
# https://bitbucket.org/jasonwryan/eeepc/src/73dadb289dead8ef17ef29a9315ba8f1706927cb/Scripts/dwm-status

# Colour codes from dwm/config.h
colour_gry="\x01" # grey on black
colour_wht="\x0D" # white on black
colour_dgry="\x04" # darkgrey on black
colour_blk="\x05" # black on darkgrey
colour_red="\x06" # colour_red on black
colour_grn="\x07" # green on black
colour_dylw="\x08" # orange on black
colour_ylw="\x09" # yellow on black
colour_blu="\x0A" # colour_blue on darkgrey
colour_mag="\x0B" # colour_magenta on darkgrey
colour_cyn="\x0C" # cyan on darkgrey

# Icon glyphs from font xbmicons.pcf
glyph_cpu="\uE00F"
glyph_mem="\uE010"
glyph_vol="\uE015"
glyph_tim="\uE016"
glyph_batt="\uE01F"
glyph_batt1="\uE022"
glyph_eth="\uE023"
sep_solid="\uE01A"
sep_line="\uE01B"
sep_bar="\uE020"

print_mem_used() {
  mem_used="$(free -m | awk 'NR==2 {print $3}')"
  echo -ne "${sep_line}${colour_blu} ${glyph_mem} ${mem_used}M "
}

print_datetime() {
  datetime="$(date "+%a %d %b ${sep_line} %H:%M")"
  echo -ne "${sep_line}${colour_blu} ${glyph_tim} ${datetime} "
}

print_batt_rem() {
  batt_rem="$(acpi | awk '{print $4}' | tr -d ',')"
  echo -ne "${sep_line}${colour_blu} ${glyph_batt} ${batt_rem} "
}

print_batt_time() {
  batrem="$(acpi | awk '{print $5}')"
  echo -ne "${sep_line}${colour_blu} ${glyph_batt1} ${batrem} "
}

print_ip() {
  ip="$(iwgetid -r)"
  echo -ne "${sep_line}${colour_blu} ${glyph_eth} ${ip} "
}

# cpu (from: https://bbs.archlinux.org/viewtopic.php?pid=661641#p661641)

while true; do
  # get new cpu idle and total usage
  eval $(awk '/^cpu /{print "cpu_idle_now=" $5 "; cpu_total_now=" $2+$3+$4+$5 }' /proc/stat)
  cpu_interval=$((cpu_total_now-${cpu_total_old:-0}))
  # calculate cpu usage (%)
  let cpu_used="100 * ($cpu_interval - ($cpu_idle_now-${cpu_idle_old:-0})) / $cpu_interval"

  # output vars
  print_cpu_used() {
    printf "%-14b" "${colour_cyn}${sep_line}${colour_blu} ${glyph_cpu} ${cpu_used}%"
  }

  # Pipe to status bar, not indented due to printing extra spaces/tabs
  xsetroot -name "$(print_cpu_used)\
$(print_ip)\
$(print_mem_used)\
$(print_batt_rem)\
$(print_batt_time)\
$(print_datetime)"

  # reset old rates
  cpu_idle_old=$cpu_idle_now
  cpu_total_old=$cpu_total_now
  # loop stats every 1 second
  sleep 1
done
