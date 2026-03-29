# Copilot Instructions

## Project Overview

This is a LaTeX academic paper for the Springer LNCS (Lecture Notes in Computer Science) series. The paper describes two contributions to **MSAGLJS** (Microsoft Automatic Graph Layout for JavaScript): a new edge routing algorithm based on Constrained Delaunay Triangulation and the funnel algorithm, and a tiling scheme for large graph visualization in web browsers.

## Build

```bash
# Full build with bibliography (pdflatex + bibtex)
pdflatex gd2026.tex && bibtex gd2026 && pdflatex gd2026.tex && pdflatex gd2026.tex

# Quick single pass (no bibliography update)
pdflatex gd2026.tex
```

SVG figures require Inkscape for conversion. Pre-converted PDFs live in `svg-inkscape/`. If Inkscape is available, `pdflatex --shell-escape` will regenerate them from the SVGs in `images/`.

## Structure

- `gd2026.tex` — **active paper** for GD 2026 submission (LIPIcs format, short paper, 250-line limit)
- `main.tex` — original LNCS-format paper (edge routing + tiling); reference material
- `main.bib` — shared bibliography (BibTeX)
- `gd-lipics-v3.cls` / `lipics-v2021.cls` — LIPIcs class files for GD 2026 (do not edit)
- `llncs.cls` / `gd-llncs.cls` — Springer LNCS class files for original paper (do not edit)
- `images/` — figures (SVG and PNG)
- `svg-inkscape/` — auto-generated PDF conversions of SVGs (do not edit manually)

## GD 2026 Submission

- **Format**: LIPIcs via `gd-lipics-v3` class. Short paper, 250-line limit (excluding front matter, refs, appendix).
- **Double-blind**: use `anonymous` class option for submission; remove for camera-ready.
- **Category macro**: `\category{Track 2, Short Paper}` — valid options include Track 1/2, Short/Long Paper, Poster Abstract.
- **Required declarations**: `\GAIDecl{...}` (generative AI) and optionally `\USEDecl{...}` (user study ethics).
- **Bibliography style**: `plainurl` (mandatory for LIPIcs).
- **Deadlines**: Abstract May 6, Paper May 13, 2026.

## Conventions

- Custom LaTeX commands for recurring notation are defined near the top of each `.tex` file (e.g., `\cdt` for triangulation 𝒯, `\plg` for polygon 𝒫, `\obst` for obstacles 𝒪). Use these instead of raw math markup.
- `\TODO{...}` marks unfinished items (renders in magenta). `\comm{...}` hides commented-out text.
- Figures use `\includesvg` for SVG sources and `\includegraphics` for PNG/PDF. Images path is `./images/`.
- Bibliography uses `\cite{key}` with entries in `main.bib`; `gd2026.tex` uses `plainurl` style, `main.tex` uses `ieeetr`.
