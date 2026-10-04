# Privacy notice — cursor-model-orchestrator

**Effective date:** 2026-10-03  
**Status:** Maintainer draft for this open-source repository. **Not a substitute for
legal advice.** If you operate a commercial service or process personal data of
others, replace placeholders and have counsel review.

## 1. Who we are

This repository publishes a **recommend-only Cursor skill** (local install).  
Maintainer contact for privacy questions about **this repository**: open a
GitHub issue on https://github.com/dapetun/cursor-model-orchestrator

Operator / company identity for a future commercial offering (fill before
publishing as a service in the Russian Federation):

- Full legal name: `{{ПОЛНОЕ_НАИМЕНОВАНИЕ}}`
- INN: `{{ИНН}}`
- OGRN / OGRNIP: `{{ОГРН}}`
- Legal address: `{{ЮР_АДРЕС}}`
- Email: `{{EMAIL}}`

Until those fields are filled and a service is offered, this project does **not**
claim to be a registered personal-data operator for end-user accounts.

## 2. What this project processes today

| Activity | Personal data? | Where |
| --- | --- | --- |
| You clone / install the skill locally | No service-side collection by this repo | Your machine |
| Skill classifies a prompt and prints `[route]` | Prompt stays in Cursor chat; skill does not ship prompts to this project's servers | Cursor / your session |
| Optional **stack** Hindsight `retain` | Lean route metadata only (tier, model, mode, pool, budget, shape, short reason). **Never** full prompts, code, secrets, or PII by design | Local Hindsight daemon (partner project), if you enable it |
| `scripts/sync_models.py` | Fetches **public** Cursor pricing docs; no end-user PII | Outbound HTTPS to cursor.com docs |

This repository does **not** run a public web app, account system, analytics
pixels, or cloud database of users.

## 3. Controllers you interact with separately

When you use Cursor and model providers, **their** terms and privacy notices
apply to prompts and completions. This skill only **recommends** which model to
select; it does not replace those providers.

Partner / upstream projects (separate controllers / processors as applicable):

- [cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand)
- GitNexus (optional)

## 4. Purposes (stack logging)

If you enable stack + Hindsight, the purpose of lean retain is **product
evaluation of routing decisions** (which tier/model was recommended), not
profiling of natural persons.

Retention: controlled by your local Hindsight configuration; this skill does not
define cloud retention.

## 5. Legal bases (informative)

- **Personal / household use of the skill:** typically outside commercial
  operator scenarios; confirm with counsel for your jurisdiction.
- **If you deploy this for an organisation** processing employee or customer
  data through Cursor: document lawful bases under GDPR Art. 6 / 152-FZ as
  applicable for **your** processing — this notice does not create those bases.

## 6. Cross-border / localisation (RF 152-FZ)

This repo does not host a БД of personal data of Russian citizens.  
If you later store such data in a cloud DB, **primary storage must be in the RF**
(152-ФЗ ст. 18 ч. 5) and cross-border transfer rules (ст. 12) may apply —
architecture decision; see [owner-actions.md](owner-actions.md).

## 7. Your rights

For data held only on **your** machine / local Hindsight: you control deletion.  
For Cursor / model providers: use their subject-request channels.  
For this GitHub repository metadata (issues, PRs): use GitHub settings / tools.

## 8. Children

Not directed at children. Do not submit children's personal data via issues or logs.

## 9. Changes

Material changes will be reflected in this file and noted in the repository
changelog / release notes when applicable.

## 10. Future commercial website checklist

Before launching a public site that collects email/phone or uses analytics,
complete the RF website checklist (cookie banner, consent gate, published
policy linked from forms, РКН notification when required). Templates for
cookies: [cookie-policy.md](cookie-policy.md).
