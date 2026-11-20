#!/bin/bash
# gta6-clipper-01 — build the vertical Short from GTA VI Trailer 2.
# Creative decision (agent, this session): ONE continuous moment, not a montage —
# the trailer's climax arc 110s–152s: the job goes wrong (fight / club chaos),
# Lucia & Jason regroup at home, then the dusk convertible getaway.
# Hook = the fight in the first seconds. Pitch text rides the last 8s.
# Vertical: full 16:9 frame kept, centred over a blurred fill (no side detail lost).
set -euo pipefail
cd "$(dirname "$0")/.."
SRC="footage/gta6-trailer2-archive.mp4"   # 1920x1080, 166.79s, Rockstar Trailer 2 (VQRLujxTm3c)
OUT="clip/gta6-clipper-01-short.mp4"
FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

ffmpeg -y -v error -ss 110 -t 42 -i "$SRC" -filter_complex "\
[0:v]split=2[bg][fg]; \
[bg]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45[bg2]; \
[fg]scale=1080:-1[fg2]; \
[bg2][fg2]overlay=(W-w)/2:(H-h)/2, \
drawtext=fontfile=$FONT:text='GTA VI Trailer 2 — the getaway':fontsize=46:fontcolor=white:borderw=2:bordercolor=black@0.8:x=(w-text_w)/2:y=140:enable='between(t,0.5,4.5)':box=1:boxcolor=black@0.55:boxborderw=20, \
drawtext=fontfile=$FONT:text='Make clips like this with AI':fontsize=62:fontcolor=white:borderw=2:bordercolor=black@0.8:x=(w-text_w)/2:y=h*0.40:enable='between(t,34,42)':box=1:boxcolor=black@0.6:boxborderw=24, \
drawtext=fontfile=$FONT:text='and earn money on make.fun':fontsize=62:fontcolor=white:borderw=2:bordercolor=black@0.8:x=(w-text_w)/2:y=h*0.455:enable='between(t,34,42)':box=1:boxcolor=black@0.6:boxborderw=24, \
drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=46:fontcolor=yellow:borderw=2:bordercolor=black@0.8:x=(w-text_w)/2:y=h*0.51:enable='between(t,34,42)':box=1:boxcolor=black@0.6:boxborderw=24, \
fps=30,format=yuv420p[v]" \
-map "[v]" -map 0:a -c:v libx264 -crf 20 -preset medium -c:a aac -b:a 128k \
-movflags +faststart -t 42 "$OUT"
ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height \
  -of default=noprint_wrappers=1 "$OUT"
echo "BUILT: $OUT"
