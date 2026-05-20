# Application security program — Phase 06: Improve and govern

**Policy alignment:** Sustains **A1, A2, D5, F2, EX**; policy review cadence — see [Policy and process alignment](../policy-process-alignment.md#process-phase-to-policy).

**Navigation:** [Program overview](../appsec-program-full-circle.md) · Previous: [Phase 05 — Runtime and operate](05-runtime-and-operate.md)

## Objective

Run application security as a measurable program with clear accountability, continuous tuning, and policy governance.

## OWASP SAMM mapping

- **Primary SAMM functions:** Governance
- **Primary SAMM practices:**
  - Governance: Strategy and Metrics, Policy and Compliance, Education and Guidance
- **Secondary SAMM practices:** Cross-cutting oversight across Design, Implementation, Verification, and Operations (all phase guides)

## Scope

- Security metrics, reporting, and maturity planning
- Exception governance and policy lifecycle
- Scanner tuning, training, and program roadmap execution
- Feedback from Phases 01–05 into policy and process updates

## Core activities

- Track KPIs and trend them over time
- Review and tune scanner rules and [severity policy](../framework/severity-policy.md)
- Manage exceptions with expiry and approvals
- Conduct quarterly control reviews and SAMM-oriented maturity planning

## Reference controls

Governance artifacts are **documentation and registry-driven**, not a single CI job:

| Artifact | Purpose |
|----------|---------|
| [Policy baseline](../framework/appsec-policy-baseline.md) | Normative requirements; annual or triggered review |
| [Severity policy](../framework/severity-policy.md) · [YAML](../framework/severity-policy.yaml) | Merge blocks and SLAs; tuning in this phase |
| [Policy evidence mapping](../framework/policy-evidence-mapping.yaml) | Catalog/CI field and job-type alignment |
| [Implementation master checklist](implementation-master-checklist.md) | Owners, dates, roadmap items |
| [SAMM coverage checklist](samm-coverage-checklist.md) | Maturity assessment |
| [Exception request form](../templates/exception-request-form.md) | Risk acceptance discipline |

## Suggested tooling

- **Metrics:** BI platform, CSV/JSON export from pipelines, catalog dashboards
- **Work tracking:** GitHub Projects, Jira, Linear
- **Governance records:** Version-controlled policy docs, issue templates, exception register
- **Maturity:** [OWASP SAMM reference](framework-owasp-samm.md), [SAMM coverage checklist](samm-coverage-checklist.md)

## Minimum viable process

- Monthly AppSec metrics review (open high/critical, MTTR, gate reliability)
- Quarterly scanner rule and severity threshold review
- Exception register with owner and **mandatory** expiry ([exception form](../templates/exception-request-form.md))
- Annual (or triggered) review of policy baseline with stakeholders

## Common pitfalls

- Tracking finding volume without remediation quality or SLA adherence
- Permanent exceptions with no expiry or compensating controls
- No feedback loop from production incidents to CI and design controls
- SAMM assessment without linked backlog items and owners

## Inputs

- Scanner outputs and artifact histories (Phases 02–05)
- Triage and incident records
- Policy exceptions, approvals, and audit requests
- SAMM self-assessment or external assessment results

## Outputs

- Program scorecard and risk posture summary
- Prioritized next-quarter security roadmap
- Policy/process change proposals and communication plan
- Updated [implementation master checklist](implementation-master-checklist.md)

## Success metrics

- MTTR by severity band
- % high/critical findings within SLA
- Exception age and exception burn-down rate
- False-positive trend by scanner and rule set
- SAMM practice scores over time (where measured)

## Adoption paths

### Minimum viable (fast to adopt)

- **Metrics:** Monthly spreadsheet or dashboard—open critical/high, MTTR, PR gate pass rate.
- **Exceptions:** Single register (issues or GRC tool); no exception without expiry date.
- **Tuning:** Quarterly 60-minute review of top false positives and one severity-policy adjustment if needed.
- **Policy:** Confirm [policy-process-alignment](../policy-process-alignment.md) still matches how teams actually work.

### Scaled (larger teams or regulated context)

- **Program office:** Dedicated AppSec owner; champions network; executive KPI/OKR cadence.
- **Training:** Role-based secure coding paths; just-in-time training from top finding categories.
- **Governance:** Annual control review; vendor/OSS review workflow; identity/SDLC access alignment.
- **Incidents:** AppSec playbooks, tabletops, mandatory retro actions in backlog.
- **Third party:** Vendor security review; OSS adoption policy tied to Phase 01 design gates.
- **Reporting:** Quarterly leadership brief on risk posture and remediation trends.

Track extended capabilities in the [implementation master checklist](implementation-master-checklist.md) and [known gaps](../README.md#known-gaps-and-roadmap).

### Tooling by use case

| Use case | Examples (tool-agnostic) |
|----------|---------------------------|
| Metrics and dashboards | Looker, Power BI, Grafana, catalog-native reporting |
| Work and roadmap | Jira, Linear, GitHub Projects |
| GRC and exceptions | ServiceNow GRC, Archer, spreadsheet + approval workflow |
| Policy and docs | Git-backed markdown (this program), Confluence with change control |
| Maturity | OWASP SAMM toolkit, internal scorecards |

### Suggested rollout (30 / 60 / 90 days)

| Horizon | Focus |
|---------|--------|
| **30 days** | Exception register live; monthly metrics template; owners on [implementation checklist](implementation-master-checklist.md) |
| **60 days** | First quarterly tuning review; SAMM baseline assessment; champions identified |
| **90 days** | Executive scorecard; policy review scheduled; top 5 roadmap items from gaps list committed |

---

**Navigation:** [Program overview](../appsec-program-full-circle.md) · **Previous:** [Phase 05 — Runtime and operate](05-runtime-and-operate.md)
