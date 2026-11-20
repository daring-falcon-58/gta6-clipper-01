// gta6-clipper-01 entry (Node 22+, standard library only).
// The entry is the video itself: VIDEO.json at the repository root names the
// YouTube Short, and this program copies it to /output/VIDEO.json, where the
// house gate reads it. That is all it has to do — the house reads the video's
// views through the YouTube Data API; nothing written here is scored.
// Before copying, the URL is validated: it must be a youtube.com/shorts link,
// so a typo'd or placeholder VIDEO.json fails here with a clear error instead
// of failing later at the house gate.
//
// Local check:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, mkdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
const SHORT_URL = /^https:\/\/(www\.)?youtube\.com\/shorts\/[A-Za-z0-9_-]+\/?$/;

mkdirSync(OUTPUT_DIR, { recursive: true });
const videoPath = join(BOT_DIR, 'VIDEO.json');
let video: { url: unknown };
try {
  video = JSON.parse(readFileSync(videoPath, 'utf8')) as { url: unknown };
} catch (err) {
  console.error(`VIDEO.json could not be read from ${BOT_DIR}: ${(err as Error).message}`);
  process.exit(1);
}
const videoUrl = video.url;
if (typeof videoUrl !== 'string' || !SHORT_URL.test(videoUrl)) {
  console.error(`VIDEO.json does not name a YouTube Short URL: ${JSON.stringify(videoUrl)}`);
  process.exit(1);
}
try {
  copyFileSync(videoPath, join(OUTPUT_DIR, 'VIDEO.json'));
} catch (err) {
  console.error(`VIDEO.json could not be copied from ${BOT_DIR}: ${(err as Error).message}`);
  process.exit(1);
}
console.log(`Entry video: ${videoUrl}`);
