# Screenshots of evidence

## Status: not yet captured

The screenshots could not be generated when this repository was prepared, because the environment used to write it had no browser access to the source websites. Rather than create images that only look like screenshots, this folder contains a capture tool that produces **real, dated, highlighted screenshots** of each source in one run on your own computer.

## Capture them (5 minutes)

```bash
pip install playwright
playwright install chromium
cd evidence
python3 tools/capture_screenshots.py          # all 22 sources
python3 tools/capture_screenshots.py E03 E14  # or just some
```

For each source in the [register](../evidence-register.md) the tool saves:

- `EXX-<name>.png`: the page scrolled to the key figure, which is highlighted in yellow.
- `EXX-<name>-full.png`: the full page.
- A row in `data/capture-log.csv` with the capture time (UTC), HTTP status, final URL, page title, whether the highlighted text was found, and a SHA-256 fingerprint of the image.

## Then check each image

- [ ] The highlighted figure or statement is visible and readable.
- [ ] The URL or page title is identifiable (if not, keep the capture log entry or add the URL in the caption below).
- [ ] No cookie banner, paywall or "verify you are human" page is covering the content. If it is, capture that source manually and save it with the same file name.
- [ ] Any `NO HIGHLIGHT` line printed by the tool has been checked by eye.
- [ ] Update `screenshot_status` in `data/evidence-register.csv` to `captured` (and re-run `python3 tools/build_registers.py` only if you edit the list inside it; otherwise edit the CSV by hand).

## Which screenshots matter most

If you only have time for a few, capture these. Together they cover the company, the market need, the regulatory trigger, the skills gap and the marketing method.

| Priority | IDs | Why |
|---|---|---|
| 1 | E01, E02 | Show exactly what Tobb and Coxygen offer, today |
| 2 | E03, E14 | Digital adoption and the youth unemployment backdrop |
| 3 | E09, E11 | POPIA enforcement context and penalty size |
| 4 | E12, E13 | Practical skills gap |
| 5 | E18, E19 | Interactive-assessment benchmarks (and their caveats) |

## Notes on use

- Screenshots of third-party pages are for internal evidence and proposal support. Do not republish them in marketing material; cite and link the source instead.
- Pages change. The capture date and fingerprint in the log show what the page said when you captured it.
- Do not commit anything containing personal data (for example, if a page shows your login).
