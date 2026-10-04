# Cookie policy — cursor-model-orchestrator

**Effective date:** 2026-10-03  
**Status:** Draft. **Not legal advice.**

## Current status (this repository)

This project **does not** operate a first-party website that sets analytics or
marketing cookies. GitHub.com may set its own cookies when you browse the
repository — that is governed by GitHub's policies, not by this project.

Therefore a first-party cookie banner is **not applicable** until a project
website with non-essential cookies exists.

## If you later ship a site (template — do not invent facts)

Publish a dedicated `/cookie-policy` page (separate from privacy) covering:

1. What cookies are and why the site uses them.
2. Table of categories:

| Category | Examples | Required? | Purpose | Lifetime |
| --- | --- | --- | --- | --- |
| Strictly necessary | session / CSRF | Yes | Auth, security | Session / short |
| Analytics | `{{ANALYTICS_VENDOR}}` | No — needs consent | Usage metrics | `{{TTL}}` |
| Marketing | `{{PIXEL_VENDOR}}` | No — needs consent | Ads attribution | `{{TTL}}` |

3. How to refuse: equal «Accept» / «Reject» on the banner; how to reopen choice.
4. Browser controls as a secondary mechanism.
5. Effect of refusal: site works; analytics/marketing disabled.

**RF practice:** do not load Metrika / GA / pixels until explicit consent
(152-ФЗ ст. 9). Silent «by continuing you agree» is not enough.

Operator requisites on the commercial site: see placeholders in
[privacy.md](privacy.md) and [owner-actions.md](owner-actions.md).
