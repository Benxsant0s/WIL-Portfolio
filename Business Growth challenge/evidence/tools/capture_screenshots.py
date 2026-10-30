"""Capture dated, highlighted screenshots of every source in the evidence register.

Setup (once):
    pip install playwright
    playwright install chromium

Run from the evidence/ folder:
    python3 tools/capture_screenshots.py            # all sources
    python3 tools/capture_screenshots.py E03 E14    # only some

For each source it saves:
  screenshots/<file>.png        viewport shot scrolled to the highlighted figure
  screenshots/<file>-full.png   full-page shot
and appends a row to data/capture-log.csv (UTC time, HTTP status, final URL,
page title, whether the highlight text was found, SHA-256 of the image).
Cookie banners, paywalls or bot checks can hide content: always open the PNG and
check that the figure is visible. If not, capture it manually and keep the same file name.
"""
import csv, hashlib, sys, datetime, pathlib
from playwright.sync_api import sync_playwright

ROOT = pathlib.Path(__file__).resolve().parent.parent
REG = ROOT / "data" / "evidence-register.csv"
LOG = ROOT / "data" / "capture-log.csv"

HIGHLIGHT_JS = """
(needle) => {
  const w = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  let n;
  while ((n = w.nextNode())) {
    const i = n.nodeValue.indexOf(needle);
    if (i >= 0 && n.parentElement && !['SCRIPT','STYLE'].includes(n.parentElement.tagName)) {
      const r = document.createRange();
      r.setStart(n, i); r.setEnd(n, i + needle.length);
      const m = document.createElement('mark');
      m.style.cssText = 'background:#ffe14d;color:#000;outline:3px solid #ff9900;padding:0 2px';
      r.surroundContents(m);
      m.scrollIntoView({block:'center'});
      return true;
    }
  }
  return false;
}
"""

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def main(only):
    rows = list(csv.DictReader(open(REG, encoding="utf-8")))
    if only: rows = [r for r in rows if r["id"] in only]
    new_log = not LOG.exists()
    with sync_playwright() as pw, open(LOG, "a", newline="", encoding="utf-8") as lf:
        lw = csv.writer(lf)
        if new_log:
            lw.writerow(["id","captured_utc","http_status","final_url","page_title","highlight_found","file","sha256"])
        b = pw.chromium.launch()
        ctx = b.new_context(viewport={"width":1280,"height":800})
        for r in rows:
            out = ROOT / r["screenshot_file"]
            out.parent.mkdir(exist_ok=True)
            page = ctx.new_page()
            status, found = "error", False
            try:
                resp = page.goto(r["url"], wait_until="domcontentloaded", timeout=45000)
                page.wait_for_timeout(2500)
                status = resp.status if resp else "none"
                if r["highlight_text"]:
                    found = page.evaluate(HIGHLIGHT_JS, r["highlight_text"])
                page.screenshot(path=str(out))
                full = out.with_name(out.stem + "-full.png")
                page.screenshot(path=str(full), full_page=True)
                lw.writerow([r["id"], datetime.datetime.utcnow().isoformat(timespec="seconds"), status,
                             page.url, page.title(), found, r["screenshot_file"], sha(out)])
                print(r["id"], status, "highlight" if found else "NO HIGHLIGHT - check manually")
            except Exception as e:
                lw.writerow([r["id"], datetime.datetime.utcnow().isoformat(timespec="seconds"), status, r["url"], "", False, "", str(e)[:120]])
                print(r["id"], "FAILED:", str(e)[:100])
            finally:
                page.close()
        b.close()

if __name__ == "__main__":
    main(set(sys.argv[1:]))
