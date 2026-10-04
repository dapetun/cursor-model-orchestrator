# Owner-only actions (cannot be completed by repo text alone)

These items remain on the maintainer / legal entity. Repo drafts do not replace them.

## 1. Ownership / IP provenance

Confirm and record privately (counsel if employed):

- [ ] Code was written on personal time **or** employer has waived / licensed rights
- [ ] Copyright holder `dapetun` in [LICENSE](../../LICENSE) is accurate
- [ ] No third-party proprietary code was copied into the skill without license

## 2. Russian Federation — if you become an operator of personal data

Triggered when you determine purposes/means of processing PD of individuals
(e.g. commercial site with forms, CRM, cloud logs of identifiable users).

- [ ] Decide whether you are an **оператор** under 152-ФЗ
- [ ] File **уведомление в Роскомнадзор** before processing when required (ст. 22)
- [ ] Publish filled [privacy.md](privacy.md) with real `{{ИНН}}` / `{{ОГРН}}` / address
- [ ] If analytics abroad: notify cross-border transfer per ст. 12 practice
- [ ] If storing RF citizens' PD: **primary DB in RF** (ст. 18 ч. 5) — not optional

Do **not** invent INN/OGRN in published pages.

## 3. Commercial offer (ЗОЗПП / оферта)

Only if you sell goods/services online:

- [ ] Publish public offer + returns policy before checkout
- [ ] Show legal name, address, phone, INN/OGRN on the commercial site
- [ ] Age rating / ERID if advertising creatives require them

## 4. EU productization

- [ ] Decide: personal tool vs product offered in the Union
- [ ] If offered: counsel review of AI Act role + GDPR RoPA / DSR process
- [ ] Keep marketing aligned with [ai-act-disclosure.md](ai-act-disclosure.md)

## 5. Incoming contracts

When a counterparty sends documents, drop them into review (do not auto-sign):

- NDA → triage against market defaults / your playbook
- ДОУ / DPA → [dpa-dou-checklist.md](dpa-dou-checklist.md)
- SaaS MSA / license → RF contract review + IP / liability caps

## 6. Already done in-repo (hygiene)

- [x] MIT LICENSE
- [x] NOTICE (trademarks)
- [x] CONTRIBUTING + DCO + CI check
- [x] Privacy / cookie / AI Act drafts under `docs/legal/`
- [x] No-prompt / no-PII retain invariant documented in skill + schema
