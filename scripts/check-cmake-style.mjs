#!/usr/bin/env node
/**
 * Lightweight CMake style guard for lint-staged / CI.
 * Flags tabs and trailing whitespace in CMake files.
 */
import fs from 'node:fs';

const files = process.argv.slice(2).filter((f) => f.endsWith('.cmake') || f.endsWith('CMakeLists.txt') || f.endsWith('.txt.in'));

if (files.length === 0) {
  process.exit(0);
}

let failed = false;
for (const file of files) {
  if (!fs.existsSync(file)) continue;
  const text = fs.readFileSync(file, 'utf8');
  const lines = text.split(/\r?\n/);
  lines.forEach((line, idx) => {
    if (/\t/.test(line)) {
      console.error(`${file}:${idx + 1}: tab character found (use spaces)`);
      failed = true;
    }
    if (/[ \t]+$/.test(line)) {
      console.error(`${file}:${idx + 1}: trailing whitespace`);
      failed = true;
    }
  });
}

process.exit(failed ? 1 : 0);
