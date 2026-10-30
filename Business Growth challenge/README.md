# Tobb Digital Readiness Check

> A free, five-minute diagnostic that shows South African organisations where they stand digitally, and turns the answer into a clear roadmap built from Tobb Technologies' services and Coxygen Universities' training.

**Prepared for:** Tobb Technologies (Pty) Ltd and its sister platform Coxygen Universities
**Prepared:** October 2026
**Status:** Proposal, ready for review
**Full proposal:** [proposal.md](./proposal.md)

---

## Table of contents

1. [Overview](#overview)
2. [Purpose](#purpose)
3. [The idea in brief](#the-idea-in-brief)
4. [Who it is for](#who-it-is-for)
5. [Benefits](#benefits)
6. [How Tobb and Coxygen can use this idea](#how-tobb-and-coxygen-can-use-this-idea)
7. [How success is measured](#how-success-is-measured)
8. [Repository contents](#repository-contents)
9. [Sources and assumptions](#sources-and-assumptions)

---

## Overview

**Tobb Technologies** is a Johannesburg-based IT consulting and software company that has operated since 2006 (formerly Now IT Wiz). Its public site lists a wide range of services: custom web and mobile applications, websites and hosting, SEO, cloud storage and backups, networking and hardware, onsite training, and process design and integration. Its stated mission is to bridge the digital divide through affordable, sustainable IT services. It also runs a graduate internship programme.

**Coxygen Universities** is a connected learning platform from the same team. It offers a training centre with courses, quizzes, projects, badges and certificates across Haskell and Plutus, Cardano and Web3, Midnight and privacy technology, full-stack development, AI, and cybersecurity and digital skills, along with events and reporting tools.

Both platforms have a lot to offer, but today a first-time visitor has to work out for themselves which of Tobb's many services they need, and how Coxygen's training fits in. This project fixes that with one simple, shareable entry point.

## Purpose

The purpose of this project is to give Tobb and Coxygen a **long-term, low-cost client acquisition engine** that:

- Attracts the right prospects by offering something useful before asking for anything.
- Shows (rather than claims) Tobb's expertise through a personalised, scored report.
- Turns every completed check into a qualified lead with a ready-made service recommendation.
- Builds authority over time through a recurring, data-backed benchmark report.
- Creates a visible bridge between Tobb's services, Coxygen's training and Tobb's internship programme.

## The idea in brief

The campaign has three connected parts:

| Part | What it is | Why it matters |
|---|---|---|
| **1. The Readiness Check** | A web-based self-assessment (about 24 questions, 5 minutes) that scores an organisation across six pillars and returns an instant personalised report. | Interactive assessments tend to convert far better than static forms, and each answer tells Tobb what the prospect needs. |
| **2. The Digital Readiness Benchmark** | A quarterly report built from anonymised, aggregated results ("how ready are South African SMEs, schools and clinics?"). | Gives Tobb original, quotable data for LinkedIn, the press, partners and SEO. |
| **3. The Readiness Clinic** | A monthly free session where supervised Tobb interns walk prospects through their results. | Turns leads into conversations, gives interns real client experience, and supports Tobb's job-creation values. |

**The six pillars scored by the check**

1. Online presence and discoverability (website, search, Google profile, email)
2. Digital operations and systems (CRM, inventory, projects, automation)
3. Payments and e-commerce
4. Data protection and security (POPIA readiness, backups, access control)
5. Skills and people (staff digital skills, training habits)
6. Infrastructure and hosting (reliability, cloud, support)

Each low-scoring pillar maps directly to Tobb services (for example SEO, standard or dynamic websites, hosting, backups, CRM or inventory applications) and to Coxygen training modules.

## Who it is for

| Audience | Why they need it |
|---|---|
| **SMEs and start-ups, Gauteng first** | South African small businesses are adopting digital tools quickly, so those without solid foundations risk falling behind. |
| **Schools, colleges and training providers** | Tobb already builds education systems; Coxygen is itself an education platform. |
| **NPOs, clinics and professional practices** | They hold personal information, so the Information Regulator's increasing enforcement of POPIA applies to them. |
| **Software companies and agencies** | Tobb says it builds for other development companies, and the check can identify overflow or white-label opportunities. |
| **Learners, graduates and employers (Coxygen side)** | Youth unemployment is very high and employers say graduates need more practical, work-ready skills. |

## Benefits

**For Tobb Technologies**
- A steady flow of pre-qualified leads who have already told Tobb what they need.
- A consistent, professional first impression that backs up nearly two decades of experience.
- Original data and content for SEO, social media and PR that competitors cannot copy.
- A natural path from a free check to paid websites, hosting, applications, support and training.
- A structured way to use and showcase interns.

**For Coxygen Universities**
- A new route to learners and corporate upskilling clients through the "Skills and people" pillar.
- Clear, evidence-based reasons to recommend specific courses.
- Real-world projects (including readiness-clinic work) that learners and interns can add to their portfolios.

**For prospective clients**
- A free, honest snapshot of where they stand, with no obligation.
- A prioritised, plain-language action plan.
- A first look at POPIA-related gaps they may not know they have.

## How Tobb and Coxygen can use this idea

1. **As the main call to action.** Put "Take the free Digital Readiness Check" on the Tobb home page, in email signatures, WhatsApp status, the Facebook group and Coxygen's community channels (Telegram, Discord, GitHub wiki).
2. **As a sales qualifier.** Send the link before a first meeting so the conversation starts from real data.
3. **As a content engine.** Turn each quarterly benchmark into a report, LinkedIn posts, short videos and a media pitch.
4. **As a partnership tool.** Offer co-branded versions to business chambers, incubators, school networks and the existing partner companies listed on Tobb's site.
5. **As a skills pipeline.** Route "Skills and people" results to Coxygen courses and offer top learners internships at Tobb.
6. **As a retention tool.** Invite existing clients to retake the check every year and show their improvement.

Technically, the check can be built on the stack Tobb already works with (PHP and MySQL on its own hosting), so it needs little new infrastructure. See the [implementation plan](./proposal.md#7-implementation-plan) for details.

## How success is measured

Success is tracked across a simple funnel, with targets to be calibrated after the first 90 days:

| Stage | Measure |
|---|---|
| Reach | Unique visits to the check page, by channel |
| Engagement | Start rate and completion rate |
| Leads | Share of completers who share contact details and consent to follow-up |
| Pipeline | Consultations booked; quotes issued |
| Revenue | New clients and project value won, and cost per acquired client |
| Impact | Interns involved, learners referred to Coxygen, benchmark citations and media mentions |

The base-case twelve-month model in the proposal assumes about 4,000 visits producing roughly 280 leads and 8 new clients. These are planning assumptions, not guarantees, and the proposal explains how they were derived and how to revise them.

## Repository contents

```text
.
├── README.md                 # This overview
├── proposal.md               # Full referenced proposal: opportunity, reasoning, solution,
│                             # implementation, benefits and measurement
├── market-asset/             # The practical marketing deliverable
│   ├── README.md
│   ├── digital-readiness-check/
│   │   ├── index.html        # Working prototype of the Check (open in any browser)
│   │   └── scoring.md        # Scoring, bands, service mapping, privacy design
│   ├── copy/                 # Social posts, WhatsApp, email sequence, partner pitch
│   └── templates/            # Client report, benchmark report, Readiness Clinic run sheet
└── evidence/                 # Proof behind the findings
    ├── README.md             # Claim-to-evidence matrix and limits of the evidence
    ├── evidence-register.md  # 22 sources with grades and paraphrased findings
    ├── company-observations.md
    ├── data/                 # Register and funnel model as CSV
    ├── screenshots/          # Capture instructions (screenshots to be captured)
    └── tools/                # Scripts to rebuild the register and capture screenshots
```

Start with [`market-asset/digital-readiness-check/index.html`](./market-asset/digital-readiness-check/index.html) to see the idea working, then [`evidence/README.md`](./evidence/README.md) to see why it is suitable.

## Sources and assumptions

- Company information comes from the public pages of [tobb.co.za](https://tobb.co.za/) and [coxygen.co/universities](https://coxygen.co/universities/index.php), read in October 2026.
- Market, labour and regulatory figures come from Stats SA, the Mastercard SME Confidence Index, Xero, Payfast, ITWeb, law-firm briefings and academic studies. Full references are in [proposal.md](./proposal.md#11-references).
- Conversion benchmarks for interactive content come mainly from marketing-software vendors, so they are treated as optimistic upper bounds and the proposal uses more conservative planning figures.
- Tobb's internal figures (average project value, current lead volume, margins) are not public. Where they are needed, the proposal leaves clearly marked placeholders for management to complete.
- Screenshots of the sources have not yet been captured. A capture tool and checklist are in [`evidence/screenshots`](./evidence/screenshots/README.md).
- This document is a marketing and business proposal. It is not legal advice, and the POPIA-related content of the check should be reviewed by a qualified legal professional before launch.
