# Benchmark graphs — phone-loadable links

The links below open each graph directly in the
[MSAGLJS WebGL renderer](https://microsoft.github.io/msagljs/renderer-webgl/index.html).
The renderer reads the `?url=…` query parameter, fetches the graph, runs
layout (IPsepCola), builds the tile pyramid, and routes edges client-side —
the whole pipeline runs in the browser, so a phone is enough.

| Graph                | Nodes  | Edges   | Format                | Open in renderer                                                                                                                                              | Original source                                                                                                       |
| -------------------- | ------ | ------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Game of Thrones      | 407    | 2 639   | JGF JSON              | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fmsagljs%2Fmain%2Fmodules%2Fcore%2Ftest%2Fdata%2FJSONfiles%2Fgameofthrones.json) | [microsoft/msagljs](https://github.com/microsoft/msagljs/blob/main/modules/core/test/data/JSONfiles/gameofthrones.json) |
| Composers            | 3 405  | 13 832  | JGF JSON              | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fmsagljs%2Fmain%2Fmodules%2Fcore%2Ftest%2Fdata%2FJSONfiles%2Fcomposers.json) | [microsoft/msagljs](https://github.com/microsoft/msagljs/blob/main/modules/core/test/data/JSONfiles/composers.json)   |
| ca-GrQc              | 5 242  | 28 980  | SNAP edge list (gz)   | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevnach%2Fpaper_msagljs%2Fmain%2Fgraphs%2Fca-GrQc.txt.gz)     | [SNAP ca-GrQc](https://snap.stanford.edu/data/ca-GrQc.html)                                                            |
| ca-HepTh             | 9 877  | 51 971  | SNAP edge list (gz)   | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevnach%2Fpaper_msagljs%2Fmain%2Fgraphs%2Fca-HepTh.txt.gz)    | [SNAP ca-HepTh](https://snap.stanford.edu/data/ca-HepTh.html)                                                          |
| ca-HepPh             | 12 008 | 237 010 | SNAP edge list        | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevnach%2Fpaper_msagljs%2Fmain%2Fgraphs%2Fca-HepPh.txt)       | [SNAP ca-HepPh](https://snap.stanford.edu/data/ca-HepPh.html)                                                          |
| ca-CondMat           | 23 133 | 186 936 | SNAP edge list        | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevnach%2Fpaper_msagljs%2Fmain%2Fgraphs%2Fca-CondMat.txt)     | [SNAP ca-CondMat](https://snap.stanford.edu/data/ca-CondMat.html)                                                      |
| Facebook combined    | 4 039  | 88 234  | SNAP edge list        | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevnach%2Fpaper_msagljs%2Fmain%2Fgraphs%2Ffacebook_combined.txt) | [SNAP ego-Facebook](https://snap.stanford.edu/data/ego-Facebook.html)                                                  |
| Deezer Europe        | 28 281 | 92 752  | CSV edge list         | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevnach%2Fpaper_msagljs%2Fmain%2Fgraphs%2Fdeezer_europe%2Fdeezer_europe_edges.csv) | [SNAP Deezer Europe](https://snap.stanford.edu/data/feather-deezer-social.html)                                        |
| delaunay\_n15        | 32 768 | 98 274  | MatrixMarket          | [open](https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=https%3A%2F%2Fraw.githubusercontent.com%2Flevnach%2Fpaper_msagljs%2Fmain%2Fgraphs%2Fdelaunay_n15%2Fdelaunay_n15.mtx) | [SuiteSparse delaunay\_n15](https://sparse.tamu.edu/DIMACS10/delaunay_n15)                                              |

The "Open in renderer" links are pinned to the copies in this repo so they
work cross-origin from a phone browser. The "Original source" column points
to the upstream archive — those URLs do not serve CORS headers and cannot be
fetched directly from a browser, but they are the citations of record.

## URL template

To load any graph hosted on a CORS-friendly origin (e.g. `raw.githubusercontent.com`),
URL-encode the graph URL and append it as `?url=` to the renderer:

```
https://microsoft.github.io/msagljs/renderer-webgl/index.html?url=<URL_ENCODED_GRAPH_URL>
```

Supported file types: `.json` (JGF or msagljs simple JSON), `.dot`, `.gv`,
`.txt` / `.tsv` / `.csv` (edge lists, `#` and `%` comments tolerated, CSV
header tolerated), `.mtx` (MatrixMarket). Any of these may also be served as
`.gz` — the renderer gunzips on the fly via `DecompressionStream`.
