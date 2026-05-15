# AppSec Program: 06 Improve and Govern

**Policy alignment:** Sustains **A1, A2, D5, F2, EX**; policy review cadence — see [policy-process-alignment.md](../policy-process-alignment.md#process-phase-to-policy).

## Objective
Run AppSec as a measurable program with clear accountability, continuous tuning, and policy governance.

## OWASP SAMM Mapping
- Primary SAMM function:
  - Governance
- Primary SAMM practices:
  - Governance: Strategy and Metrics, Policy and Compliance, Education and Guidance
- Secondary mapping:
  - Cross-cutting oversight across Design, Implementation, Verification, and Operations

## Scope
- Security metrics and reporting
- Exception governance
- Program maturity and roadmap execution

## Core Activities
- Track KPIs and trend them over time
- Review and tune scanner rules and thresholds
- Manage exceptions with expiry and approvals
- Conduct quarterly control reviews and maturity planning

## Suggested Tooling
- Metrics and dashboards: BI/reporting platform, CSV/JSON aggregation
- Work tracking: GitHub Projects/Jira/Linear
- Governance records: markdown docs + issue templates in repo

## Minimum Viable Process
- Monthly AppSec metrics review
- Quarterly control/rule tuning review
- Exception register with owner + expiry mandatory ([`../templates/exception-request-form.md`](../templates/exception-request-form.md))

## Common Pitfalls
- Tracking findings volume but not remediation quality
- Permanent exceptions with no expiry
- No feedback loop from production incidents to CI controls

## Inputs
- Scanner outputs and artifact histories
- Triage/incident records
- Policy exceptions and approvals

## Outputs
- Program scorecard
- Updated risk posture summary
- Prioritized next-quarter security roadmap

## Success Metrics
- MTTR by severity band
- % high/critical findings within SLA
- Exception age and exception burn-down
- False-positive trend by scanner/rule set

## Cross-Link
- Overview and backlog: [`../appsec-program-full-circle.md`](../appsec-program-full-circle.md)
