# AppSec program — standard forms and checklists

Use these **standard forms** for governance, design, build, and release. They support the [policy baseline](../framework/appsec-policy-baseline.md) and evidence in the [catalog / metadata mapping](../framework/policy-evidence-mapping.yaml). Replace bracketed placeholders (`[like this]`) with your organization’s specifics when publishing internally.

**Related policy:** [`../framework/appsec-policy-baseline.md`](../framework/appsec-policy-baseline.md) · **Severity gates:** [`../framework/severity-policy.md`](../framework/severity-policy.md) · **Glossary:** [`../glossary.md`](../glossary.md) · **Evidence mapping:** [`../framework/policy-evidence-mapping.yaml`](../framework/policy-evidence-mapping.yaml)

| Template | Use when | Policy / evidence |
|----------|----------|-------------------|
| [risk-tier-rubric.md](risk-tier-rubric.md) | Registering or re-reviewing an application | Risk tier and review cadence; registry `risk_tier` |
| [data-classification-scheme.md](data-classification-scheme.md) | Defining org-wide data labels | Metadata `data_classification`; contextual enhancements |
| [threat-model-catalog-lite.md](threat-model-catalog-lite.md) (+ [schema](threat-model-catalog-schema.yaml)) | Catalog/inventory, web forms, JSON storage | Threat modeling; `threat_model_document` |
| [threat-model-template.md](threat-model-template.md) | Index — lite vs full | Same |
| [threat-model-template-full.md](threat-model-template-full.md) | Optional depth, diagrams | Same |
| [adr-template.md](adr-template.md) | Architecture decisions with security impact | Security requirements; design review |
| [pr-security-checklist.md](pr-security-checklist.md) | Every pull request (or security-sensitive PRs) | Security impact on pull requests |
| [exception-request-form.md](exception-request-form.md) | Bypassing a MUST control or weaker severity gate | Exception governance (`AS-GOV-001`) |
| [release-sign-off-checklist.md](release-sign-off-checklist.md) | Production (or staged) release | Release security evidence bundle (`AS-REL-001`) |

## Suggested placement

| Artifact | Typical location |
|----------|------------------|
| Risk tier rubric, data classification | GRC wiki, AppSec catalog, or `policy/` repo |
| Threat model, ADR | `docs/security/` or `docs/adr/` in the service repo |
| PR checklist | `.github/PULL_REQUEST_TEMPLATE.md` or `.gitlab/merge_request_templates/` |
| Exception form | Ticketing system (Jira/ServiceNow) or security portal |
| Release sign-off | Release ticket, change record, or deployment pipeline gate |
