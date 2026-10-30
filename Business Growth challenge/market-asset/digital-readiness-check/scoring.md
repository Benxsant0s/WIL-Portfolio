# Scoring guide

How the Digital Readiness Check turns answers into a score. Anyone at Tobb can change the wording or weights by editing the `P` array at the top of the script in [`index.html`](./index.html).

## Structure

- 6 pillars × 4 questions = 24 questions.
- Each question has 4 answers worth 0, 1, 2 or 3 points (first option = 0, last = 3).
- **Pillar score** = (sum of the pillar's 4 answers ÷ 12) × 100, rounded.
- **Overall score** = average of the six pillar scores, rounded.
- All pillars carry equal weight. If Tobb wants to weight them (for example, to give data protection more weight for clinics), change the final average in `results()`.

## Maturity bands

| Overall score | Band | Message shown |
|---|---|---|
| 80-100 | Advanced | Strong foundations; focus on optimising and automating |
| 60-79 | Established | Good base with clear gaps to close |
| 35-59 | Emerging | Some foundations in place; a focused 90-day plan will pay off |
| 0-34 | Foundation | At the start; begin with the quick wins |

Bar colours: 70+ green, 40-69 amber, below 40 red.

## Quick wins logic

1. Every answer scoring below 3 has an attached "fix" sentence.
2. Answers are sorted lowest score first (ties broken by the weaker pillar).
3. The top three are shown, with a maximum of two from any single pillar so the advice is spread out.
4. If every answer scores 3, the report says so and points to optimisation and support.

## Service recommendations

Up to three pillars scoring below 60 are shown, lowest first, each with the matching Tobb service codes (from tobb.co.za) and, where relevant, Coxygen learning paths.

| Pillar | Tobb services (site codes) | Coxygen link |
|---|---|---|
| Online presence | S5014 standard site, SE006 SEO, WE005 email, LD007/GD009 logo and design | none |
| Operations and systems | CR31 CRM, ID39 inventory and database, PM37 project management, process flow and integration | none |
| Payments and e-commerce | CS017 simple store, CA20 advanced commercial, ECW4 e-commerce app | none |
| Data protection and security | BU008 backups, CS003 cloud, WH002 hosting and support | Cybersecurity and Digital Skills |
| Skills and people | Onsite or online training | Full-Stack Development, Cybersecurity and Digital Skills, AI and Emerging Technology |
| Infrastructure and hosting | DR001/WH002 domain and hosting, CS003 cloud, network and hardware | none |

## Privacy design (important)

- The page has **no server, no cookies, no analytics and no storage**. Scoring happens in the visitor's browser.
- Contact only happens if the visitor presses a share button (WhatsApp or email), which pre-fills a message they can edit before sending. That is their own action and their own consent to be contacted about their results.
- If Tobb later adds a server-side lead database, it must first add: a privacy notice, an explicit marketing consent checkbox (unticked by default), an Information Officer contact, a retention period and a deletion route. Have a legal adviser review this before launch.

## Calibration after launch

After the first 100 completions, review: questions where more than 90% pick the same answer (add nuance or drop), questions people skip or abandon on, and whether the bands feel fair to pilot clients. Record any change in a version note at the top of this file.
