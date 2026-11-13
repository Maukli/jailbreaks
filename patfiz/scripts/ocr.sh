#!/usr/bin/env bash
# OCR скан-PDF (рус+англ) -> текст по страницам.
# Использование: ocr.sh input.pdf out_dir
set -euo pipefail
in="$1"; out="$2"; mkdir -p "$out/png"
pdftoppm -r 200 -gray -png "$in" "$out/png/p"
ls "$out"/png/*.png | xargs -P "$(nproc)" -I{} sh -c 'tesseract "{}" "${1%.png}" -l rus+eng --psm 3 >/dev/null 2>&1' _ {}
for f in $(ls "$out"/png/*.txt | sort -V); do
  echo "===== $(basename "$f" .txt) ====="; cat "$f"; echo
done > "$out/text.txt"
echo "Готово: $out/text.txt"
