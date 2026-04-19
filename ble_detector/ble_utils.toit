conv-to-mac-address str/string -> string :

  clean := str[2 .. str.size - 1].trim
  parts := clean.split ", "

  mac-address/string := ""

  parts.size.repeat: | i |
    part := parts[i].trim
    if part.size < 3 or part[0..2] != "0x" :
      throw "Invalid hex part: $part"
    hex-str := part[2..]
    if (i > 0) :
      suffix/string := i < (parts.size - 1) ? ":" : ""
      mac-address += "$hex-str$suffix"

  return mac-address

time -> string :
  time := Time.now.local
  ms := time.ns / Duration.NANOSECONDS_PER_MILLISECOND
  precise_ms := "$(%04d time.year)/$(%02d time.month)/$(%02d time.day) $(%02d time.h):$(%02d time.m):$(%02d time.s).$(%03d ms)"
  return precise_ms
