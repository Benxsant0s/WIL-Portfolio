# Market asset: the Tobb Digital Readiness Check kit

This folder contains the **actual, ready-to-use marketing deliverables** described in [`../proposal.md`](../proposal.md).

## What is inside

| Item | Path | What it is |
|---|---|---|
| **Working prototype** | [`digital-readiness-check/index.html`](./digital-readiness-check/index.html) | The complete Check: 24 questions, scoring, radar chart, quick wins, service matching, share and print options. A single file with no dependencies. |
| Scoring guide | [`digital-readiness-check/scoring.md`](./digital-readiness-check/scoring.md) | How scores, bands, quick wins and service recommendations work, and how to change them. |
| Social and messaging copy | [`copy/social-and-messaging.md`](./copy/social-and-messaging.md) | Website banner, four-week LinkedIn run, community posts, WhatsApp, video script. |
| Email sequence | [`copy/email-sequence.md`](./copy/email-sequence.md) | Three opt-in follow-up emails. |
| Partner pitch | [`copy/partner-pitch.md`](./copy/partner-pitch.md) | Email and leaflet text for chambers, incubators and school networks. |
| Client report template | [`templates/sample-results-report.md`](./templates/sample-results-report.md) | What interns and consultants send after a review. |
| Benchmark template | [`templates/benchmark-report-template.md`](./templates/benchmark-report-template.md) | Structure for the quarterly report. |
| Clinic run sheet | [`templates/clinic-run-sheet.md`](./templates/clinic-run-sheet.md) | Agenda and checklists for the monthly Readiness Clinic. |

## Try the prototype

Open `digital-readiness-check/index.html` in any browser. No server or install is needed. It also works from GitHub Pages: enable Pages for the repository and point it at this folder.

Features:
- Six pillars, 24 questions, one pillar per screen, with a progress bar.
- Instant score out of 100, maturity band, radar chart and per-pillar bars.
- Three quick wins and the Tobb service codes and Coxygen learning paths that match the weakest pillars.
- Share via WhatsApp (+27 73 182 0631) or email (admin@tobb.io), copy a text summary, or print or save as PDF.
- Light and dark mode, keyboard accessible, works on phones.

## Privacy by design

The prototype stores nothing and sends nothing. Scoring runs in the visitor's browser. Contact happens only when the visitor presses a share button. See [`scoring.md`](./digital-readiness-check/scoring.md#privacy-design-important) before adding any lead database.

## Before launch: checklist

- [ ] Replace `[CHECK_URL]`, `[BOOKING_LINK]` and other placeholders in the copy.
- [ ] Confirm contact details (WhatsApp number and email address) shown in the tool.
- [ ] Have the data protection wording and any consent text reviewed by a legal adviser.
- [ ] Pilot with 10-15 existing clients and refine questions using the calibration notes in the scoring guide.
- [ ] Add Tobb's logo and brand colours if desired (all colours are CSS variables at the top of `index.html`).
- [ ] Agree a baseline of current monthly enquiries so results can be compared.

## Using it with the evidence

Every statistic used in the copy is traceable to [`../evidence`](../evidence/README.md) by its evidence ID.
