# Evidence

This folder holds the evidence behind [`../proposal.md`](../proposal.md): every external fact, where it came from, how reliable it is, and how it supports the case that the Digital Readiness Check suits Tobb Technologies and Coxygen Universities.

## Contents

| File | Purpose |
|---|---|
| [`evidence-register.md`](./evidence-register.md) | Readable table of all 22 sources (E01-E22) with reliability grade, paraphrased finding and where it is used |
| [`data/evidence-register.csv`](./data/evidence-register.csv) | The same register as data (also drives the screenshot tool) |
| [`data/funnel-model.csv`](./data/funnel-model.csv) | The low, base and high planning model from proposal section 9.2 |
| [`company-observations.md`](./company-observations.md) | What the Tobb and Coxygen sites show, mapped to each pillar, plus gaps to fix and data only Tobb holds |
| [`screenshots/`](./screenshots/README.md) | Where screenshots of each source go, with a tool to capture them (**not yet captured**) |
| [`tools/`](./tools) | `build_registers.py` (rebuilds the register and funnel CSV) and `capture_screenshots.py` (captures dated, highlighted screenshots) |

## How the evidence supports the idea

Strength reflects the quality and directness of the evidence, not how much the idea is liked.

| # | Claim | Evidence | Strength | Why this rating |
|---|---|---|---|---|
| 1 | Tobb and Coxygen already offer what the Check would recommend, so no new services are needed | E01, E02 | **Strong** | Direct from the companies' own sites; see the [offering-to-pillar map](./company-observations.md#1-offering-to-pillar-map) |
| 2 | South African SMEs are adopting digital tools but unevenly, so a diagnostic and roadmap has a market | E03, E04, E05, E06, E07 | **Moderate** | Sources are commercial surveys and academic work with small or unusual samples. Mastercard also reports strong digital foundations, so the target should be organisations the Check finds with gaps, not all SMEs |
| 3 | Data protection enforcement gives organisations a concrete, urgent reason to act | E08, E09, E10, E11 | **Moderate to strong** | Law-firm briefings agree on the direction. The R10 million penalty figure comes from a commercial source and should be verified against the Act |
| 4 | Employers need practical digital skills and many graduates lack work-ready experience, which supports Coxygen training and Tobb internships | E12, E13, E15, E21 | **Moderate to strong** | Several independent trade and survey sources agree. The Xpatweb figures are preliminary |
| 5 | Youth unemployment is very high, which supports the social value of internships and clinics | E14, E16, E17, E20 | **Strong** | Official Stats SA data, reported by government and press |
| 6 | An interactive assessment captures leads better than a static form or download | E18, E19, E22 | **Weak to moderate** | Benchmarks come from software vendors and measure people who already started a quiz. The proposal therefore uses conservative figures |
| 7 | The programme is cheap to build and run | E01 (own hosting, PHP/MySQL, internships) | **Moderate** | Based on stated capabilities; real cost needs Tobb's input |
| 8 | Results can be measured | [`funnel-model.csv`](./data/funnel-model.csv), proposal section 9 | **Strong** | Every step in the funnel has a defined, trackable metric |

### How the idea benefits the company as a whole

| Part of Tobb or Coxygen | How it benefits | Evidence |
|---|---|---|
| Sales and business development | Pre-qualified leads with a score, gaps and matched services | E01, E18, E19 |
| Software and web delivery | A steady pipeline of the projects it already delivers (sites, CRM, stores, hosting) | E01, E03, E04 |
| Hosting and support | Recurring revenue triggered by backup, security and infrastructure gaps | E01, E08-E11 |
| Internship programme | Real, supervised client work through clinics | E01, E12, E14, E16 |
| Coxygen learning platform | Learner and corporate upskilling leads from the Skills pillar | E02, E12, E13, E15 |
| Brand and partnerships | Original benchmark data and a shareable asset for partners | E01, proposal section 5 |

## What the evidence does not prove

Being clear about the limits makes the proposal more credible:

- **No Tobb internal data.** Average project value, current enquiries, win rates and traffic are not public, so revenue is not estimated.
- **No primary research yet.** None of the sources asked Tobb's own target customers whether they would use the Check.
- **Vendor-heavy marketing benchmarks.** They suggest the direction but not the exact result Tobb will see.
- **The prototype is untested with real users.** It passes automated logic checks but has not been piloted.
- **Screenshots are pending.** Until captured, the register's links and paraphrases are the evidence.

## Cheapest ways to close those gaps (in order)

1. **Pilot the prototype** with 10-15 existing clients or partners and record scores, drop-off points and feedback.
2. **Interview five target customers** (for example SME owners, a school administrator, a clinic manager) and ask what they would do with their report.
3. **Smoke-test demand**: publish the Check with a campaign tag on one or two channels for 30 days and compare real start and completion rates with the model.
4. **Capture the baseline** of current enquiries and wins for three months.
5. **Run `capture_screenshots.py`** and complete the screenshot checklist.

## Keeping the evidence current

Re-check sources quarterly (Stats SA releases each quarter; the Information Regulator and law firms publish updates throughout the year). To add a source, add a row to the list in `tools/build_registers.py`, run it, and cite the new ID.
