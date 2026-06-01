#!/usr/bin/env python3
"""Aggregate smoothness-results.jsonl into per-graph LaTeX rows.

Post-processor for the browsing-smoothness table (tab:smoothness) in
gd2026.tex. The raw JSONL inputs are produced by the puppeteer harness
that lives with the demo it drives:

    ~/dev/msagljs/examples/webgl-sleeve/bench/smoothness.mjs

The canonical results file used for the paper is
smoothness-results-mcp.jsonl (in this directory); reproducing its
numbers requires re-running smoothness.mjs against a built copy of
the webgl-sleeve example.

Usage:
    python3 format_smoothness.py smoothness-results-mcp.jsonl
"""
import json
import sys
from statistics import mean

ORDER = [
    ("gameofthrones",      "gameofthrones",      407,   2639),
    ("composers",          "composers",          3405,  13832),
    ("ca-GrQc",            "ca-GrQc",            5242,  28968),
    ("ca-HepTh",           "ca-HepTh",           9877,  51946),
    ("facebook_combined",  "facebook\\_combined", 4039, 88234),
    ("ca-HepPh",           "ca-HepPh",           12008, 236978),
    ("ca-CondMat",         "ca-CondMat",         23133, 186878),
    ("deezer_europe",      "deezer\\_europe",     28281, 92752),
    ("delaunay_n15",       "delaunay\\_n15",      32768, 98274),
]

def fmt_int(n):
    s = f"{int(round(n)):,}".replace(",", "\\,")
    return s

def main(paths):
    by_graph = {}
    for path in paths:
        with open(path) as f:
            for line in f:
                line = line.strip()
                if not line: continue
                r = json.loads(line)
                by_graph.setdefault(r["graph"], []).append(r)
    for key, label, V, E in ORDER:
        rows = by_graph.get(key, [])
        rows = [r for r in rows if not r.get("error") and r.get("summary")]
        if not rows:
            print(f"    {label:18s} & {fmt_int(V):>7s} & {fmt_int(E):>7s} & ? & --- & --- & --- & --- \\\\")
            continue
        Z = rows[0].get("tilePyramidLevels", "?")
        lt_counts = [r["summary"]["longTasks"]["count"] for r in rows]
        lt_totals = [r["summary"]["longTasks"]["totalMs"] for r in rows]
        p95s = [r["summary"]["frame"]["p95"] for r in rows]
        peak_max = max(r["summary"]["peakElements"]["max"] for r in rows)
        # averages over trials
        lt_avg = mean(lt_counts)
        lttot_avg = mean(lt_totals)
        p95_avg = mean(p95s)
        # If averages are tiny, show one decimal
        lt_str = f"{lt_avg:.1f}" if lt_avg != int(lt_avg) else f"{int(lt_avg)}"
        lttot_str = f"{lttot_avg:.0f}"
        p95_str = f"{p95_avg:.1f}"
        peak_str = fmt_int(peak_max)
        print(f"    {label:18s} & {fmt_int(V):>7s} & {fmt_int(E):>7s} & {Z} & {lt_str:>4s} & {lttot_str:>6s} & {p95_str:>6s} & {peak_str:>8s} \\\\  % n={len(rows)}")

if __name__ == "__main__":
    main(sys.argv[1:] if len(sys.argv) > 1 else ["smoothness-results.jsonl"])
