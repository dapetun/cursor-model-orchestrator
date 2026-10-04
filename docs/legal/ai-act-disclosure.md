# EU AI Act — transparency disclosure (issue-spotting)

**Not legal advice. Not a compliance verdict.** Educational disclosure for
users and maintainers. Verify current law against Official Journal texts
(Regulation (EU) 2024/1689 as amended, including Regulation (EU) 2026/1744).

## What this software is

**cursor-model-orchestrator** is a **recommend-only** Cursor skill. It:

- classifies prompts with **deterministic** keyword / project-type rules;
- recommends a model under a Cursor Pro budget policy;
- prints a Russian `[route]` explanation;
- does **not** force the Cursor model picker, spawn subagents (v0.1), or host
  a general-purpose AI model.

You already interact with **Cursor** and chosen model providers. This skill is
an overlay that suggests which model to use.

## Roles (you must decide)

Depending on how you offer and use the skill, you may be a user of Cursor, a
deployer in an organisation, or (if you place a product on the EU market) a
provider under the AI Act. **This file does not assign your legal role.**

- Purely personal / non-professional use may engage different deployer
  exclusions — confirm with counsel (see Art. 2 scope discussions in official
  materials).
- If you productize for EU organisations, obtain counsel on provider vs
  deployer duties before marketing claims.

## Transparency (Article 50 — when it may matter)

Article 50 transparency obligations (application from **2 August 2026**, subject
to transitions in the amended act) concern AI systems that interact with
persons and certain synthetic content.

For this skill:

- The `[route]` line is a **routing recommendation**, not generative media.
- End users are typically already aware they are in an AI coding assistant.
- If you wrap this skill into a **new** consumer-facing chatbot or publish
  AI-generated content at scale, reassess Art. 50 labelling / disclosure with
  counsel.

## What we are not claiming

This repository does **not** claim:

- that the skill is or is not an «AI system» under Art. 3;
- high-risk / prohibited / GPAI provider status;
- that any fine ceiling will or will not apply.

High-risk Annex III use cases (employment, credit scoring, biometrics,
law-enforcement decisioning, etc.) are **out of the intended purpose** of this
skill. Do not market or configure it for those purposes.

## Human decisions still required

1. Confirm intended purpose and whether you place anything on the EU market.
2. If productizing, commission an EU AI Act review against live Official Journal
   text.
3. Keep product copy accurate: recommend-only router, not a substitute for
   Cursor Auto / provider compliance.

Official entry points (verify live):  
https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32024R1689  
https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai
