# ДОУ / DPA checklist (when processing on behalf of another)

Use when a customer or vendor requires a **ДОУ** (поручение обработки ПДн,
152-ФЗ ст. 6 ч. 3) or a GDPR **Art. 28** Data Processing Agreement.

**Not legal advice.** Do not sign without DPO / counsel.

## Direction (pick one before reviewing terms)

| Situation | Your role |
| --- | --- |
| Customer sends you their ДОУ / DPA to process *their* data in *your* stack | You ≈ processor / лицо по поручению |
| You send ДОУ to a vendor (hosting, support tool) that will process *your* / *your clients'* data | You ≈ operator / controller |

Wrong direction inverts every redline.

## Mandatory elements — 152-ФЗ ст. 6 ч. 3

A RF ДОУ that omits any of these is formally incomplete:

1. List of **actions** with personal data (сбор, хранение, удаление, … — specific)
2. **Purposes** of processing (concrete, not «оказание услуг»)
3. Obligation of **confidentiality**
4. Obligation to ensure **security** of personal data
5. Protection requirements aligned with **ст. 19** / levels under PP RF 1119 where applicable

Also check:

- **Локализация** (ст. 18 ч. 5) if Russian citizens' PD is in scope — primary storage in RF
- **Cross-border** (ст. 12) + RKN notification practice when transfer abroad
- Sub-processors: approval / notice / cascade obligations
- Incident notice to the operator (target practice often **24h**)
- Audit rights; deletion / return on termination (e.g. 30–90 days)
- Consistency with your published privacy notice

## GDPR Art. 28 (if EU personal data)

Confirm subject matter, duration, nature/purpose, types of data, categories of
subjects, controller instructions, confidentiality, security (Art. 32),
sub-processor rules, assistance with DSRs / breaches / DPIAs, deletion or
return, audit rights, transfer mechanism (SCCs / adequacy / etc.).

## This repository today

The OSS skill **does not** by itself create a hosted processing service for
third-party PD. Local Hindsight retain (stack) is under **your** control.

If you later sell a hosted orchestration / logging service, draft ДОУ/DPA
**before** onboarding customers and align infrastructure with localisation
rules where RF PD applies.
