#!/usr/bin/env bash
#
# Build the source bundle for arXiv submission of "Browsing Large Graphs
# with Tile Pyramids and Sleeve Routing in the Browser".
#
# arXiv compiles with TeX Live, *without* --shell-escape, and does NOT
# run bibtex on submitted sources.  We therefore:
#   1. Run a full local pdflatex + bibtex + pdflatex + pdflatex pipeline
#      to produce arxiv.bbl.
#   2. Bundle arxiv.tex, arxiv.bbl, and the figure files referenced by
#      the paper into arxiv-submission.tar.gz.
#
# Output:
#   arxiv-submission.tar.gz   (ready for upload at https://arxiv.org/submit)
#
# Usage:
#   ./build-arxiv-tarball.sh
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

DRIVER=arxiv
STAGE="$ROOT/.arxiv-staging"
OUT="$ROOT/arxiv-submission.tar.gz"

echo "==> Building $DRIVER.pdf with a clean LaTeX pipeline..."
rm -f "$DRIVER".{aux,bbl,blg,log,out,toc,pdf}
pdflatex -no-shell-escape -interaction=nonstopmode -halt-on-error "$DRIVER.tex" >/dev/null
bibtex "$DRIVER" >/dev/null
pdflatex -no-shell-escape -interaction=nonstopmode -halt-on-error "$DRIVER.tex" >/dev/null
pdflatex -no-shell-escape -interaction=nonstopmode -halt-on-error "$DRIVER.tex" >/dev/null

if ! grep -q "Output written on $DRIVER.pdf" "$DRIVER.log"; then
  echo "Error: $DRIVER.pdf did not build cleanly. See $DRIVER.log." >&2
  exit 1
fi

echo "==> Collecting figure files referenced by the paper..."
rm -rf "$STAGE"
mkdir -p "$STAGE/images"

# Parse the build log for actual \includegraphics targets so we ship only
# the figures the paper consumes (not the whole images/ directory).
# We grep "pdftex.def Info" lines, which are emitted unwrapped — the
# alternative "<./images/foo.png>" markers are subject to log-line wrapping
# at 79 chars and can split filenames across lines.
FIGS=$(grep -oE "pdftex\.def Info: \./images/[A-Za-z0-9_.-]+\.(pdf|png|jpg|jpeg)" "$DRIVER.log" \
  | sed -E 's|.*\./images/||' | sort -u)

if [[ -z "$FIGS" ]]; then
  echo "Error: no figures detected in $DRIVER.log; aborting." >&2
  exit 1
fi

for f in $FIGS; do
  cp -v "images/$f" "$STAGE/images/$f"
done

echo "==> Copying TeX sources and bibliography artefacts..."
cp -v "$DRIVER.tex" "$STAGE/"
cp -v "$DRIVER.bbl" "$STAGE/"
# main.bib is optional once .bbl exists; ship it for transparency.
cp -v main.bib "$STAGE/"

echo "==> Creating $OUT ..."
rm -f "$OUT"
# Suppress macOS extended-attribute "._*" AppleDouble sidecars (visible on
# Linux extraction even though `tar -tzf` doesn't list them on macOS).
COPYFILE_DISABLE=1 tar -C "$STAGE" --no-xattrs --no-mac-metadata -czf "$OUT" . 2>/dev/null \
  || COPYFILE_DISABLE=1 tar -C "$STAGE" -czf "$OUT" .
echo
echo "Bundle contents:"
tar -tzf "$OUT" | sort

echo
echo "Done. Upload $OUT at https://arxiv.org/submit"
echo "Local PDF: $ROOT/$DRIVER.pdf"
