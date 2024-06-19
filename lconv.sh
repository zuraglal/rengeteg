#!/bin/sh --
#
# lconv.sh: convert HTML to simplified HTML for old tablets
# by pt@fazekas.hu at Wed Jun 19 12:33:10 CEST 2024
#
# Example: ./lconv.sh parkakl.html
#

set -ex

test "${0%/*}" = "$0" || cd "${0%/*}"

set -ex

for F in "$@"; do  # Each argument is an output HTML file name.
  F0="${F%[a-z].html}".html
  test "$F0" != "$F.html"
  perl -0777 -wpe 'use integer; use strict;
      s@<body>@<body class=l>@g;
      s@<script>.*?</script>@@sg;
      s@<div class=conv>@<div class=its>@g;
      pos($_) = 0; my %roles;
      while (/\nspan[.]([A-Z])[ \t]*\{[^\n]*\/[*]@[ \t]*([^<>\\\x27"*\/\t\r\n;{}]+?)[ \t]*[*]\//g) { $roles{$1} = $2 }
      s~<X>(.*?)<\/X>~<audio controls><source src="$1.mp3" type="audio/mpeg"></audio>~gsi;
      s~<S-([0-9])>(.*?)</S-\1>~<div class=it><span class=IUC>* $2</span></div>~gsi;
      s~<S-([A-Z])>(.*?)<\/S-\1>~<div class=it><span class="sp $1">$roles{$1}</span>: <span class=T$1>$2</span></div>~gsi;
      s~<(I[UV])>(.*?)<\/\1>~<span class=${1}C>$2</span>~gsi;
      s~\@([A-Z0-9])~<span class="sp $1">$roles{$1}</span>~g;
      ' <"$F0" >"$F"
done

: "$0" OK.
