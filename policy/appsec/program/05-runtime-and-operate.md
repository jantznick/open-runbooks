# Application security program — Phase 05: Runtime and operate

**Policy alignment:** Satisfies **F1, F2** — see [Policy and process alignment](../policy-process-alignment.md#process-phase-to-policy).

**Navigation:** [Program overview](../appsec-program-full-circle.md) · Previous: [Phase 04 — Release and deploy](04-release-and-deploy.md) · Next: [Phase 06 — Improve and govern](06-improve-and-govern.md)

## Objective

Continuously detect exposure and security drift in deployed environments and respond quickly.

## OWASP SAMM mapping

- **Primary SAMM functions:** Operations
- **Primary SAMM practices:**
  - Operations: Incident Management, Environment Management, Operational Management
- **Secondary SAMM practices:** Governance — Strategy and Metrics; Verification — Security Testing

## Scope

- Internet-facing services and APIs
- Cloud and Kubernetes runtime posture
- Incident detection, triage, and response workflows
- Scheduled re-scan cadence per [policy baseline](../framework/appsec-policy-baseline.md)

## Core activities

- Monitor external attack surface and exposure changes
- Run periodic runtime vulnerability and misconfiguration scans
- Triage alerts and execute incident response playbooks
- Tie re-scan cadence to risk tier and change frequency

## Reference controls

**F1 (scheduled re-scan)** for internet-facing applications reuses DAST reference jobs on a schedule—see [ZAP](../../runbooks/appsec/dast-zap-basic.md) and [Nuclei](../../runbooks/appsec/dast-nuclei-basic.md). Cloud posture (CSPM/KSPM) and attack-surface platforms are **roadmap** items—[known gaps](../README.md#known-gaps-and-roadmap).

| Control | Policy ID | Status in reference package |
|---------|-----------|------------------------------|
| Scheduled DAST | F1 | [ZAP](../../runbooks/appsec/dast-zap-basic.md) · [Nuclei](../../runbooks/appsec/dast-nuclei-basic.md) (scheduled CI/cron) |
| Runtime alerting / IR | F2 | Process + SIEM/ticketing (org-specific) |
| Cloud/K8s posture | — | Roadmap |

## Suggested tooling

- **Scheduled external scanning:** ZAP/Nuclei profiles in CI cron or dedicated scanner infrastructure
- **Cloud posture:** CSPM/KSPM (org-standard)
- **Detection and response:** SIEM, on-call routing, ticket platform with runbook links
- **Severity and SLAs:** [Severity policy](../framework/severity-policy.md) for runtime findings

## Minimum viable process

- Weekly or biweekly scheduled scans for critical internet-facing services
- On-call or security queue ownership for high-severity runtime alerts
- Incident workflow with severity, escalation, and post-incident notes
- Findings enter same triage/exception discipline as CI (owner, SLA, expiry)

## Common pitfalls

- Strong CI gates but no runtime monitoring or rescans
- Alert volume without triage process or runbooks
- No closure loop from incidents back into preventive controls (Phase 02–04)
- Scanning staging URLs that do not match production exposure

## Inputs

- Deployed endpoint inventory and environment metadata
- Application `risk_tier`, owners, and `app_id` from registry
- Prior incident and finding history

## Outputs

- Runtime findings and incident records
- Time-bounded remediation tasks
- Post-incident lessons and control updates (fed to Phase 06)

## Success metrics

- Mean time to detect (MTTD) and remediate (MTTR) for security incidents
- % critical runtime findings remediated within SLA
- Reduction in recurring incident classes quarter over quarter

## Adoption paths

### Minimum viable (fast to adopt)

- **Rescans:** Cron or scheduled pipeline using same DAST jobs as Phase 03 against production or production-like URLs.
- **Ownership:** Named owner per service for runtime findings; escalations documented.
- **Incidents:** Lightweight playbook (detect → triage → fix → retro); link tickets to `app_id`.
- **Cadence:** Weekly/biweekly for internet-facing tier-1/2 apps per baseline.

### Scaled (larger teams or regulated context)

- **Attack surface:** Continuous external discovery; diff alerts on new hosts/paths/certificates.
- **Posture:** CSPM/KSPM with route to same severity policy and exception process.
- **Operations:** SIEM correlation rules; tabletop exercises; mandatory retro for sev-1/2.
- **Feedback:** Quarterly “top runtime classes” drives Phase 03 rule and Phase 01 threat model updates.

### Tooling by use case

| Use case | Examples (tool-agnostic) |
|----------|---------------------------|
| Scheduled DAST | ZAP, Nuclei, Burp Enterprise schedules |
| Attack surface | ASM platforms, external port scanners, certificate monitoring |
| Cloud/K8s posture | CSPM, KSPM, cloud-native security hubs |
| Incident management | PagerDuty, Opsgenie, Jira, ServiceNow |
| Detection | SIEM, cloud-native alerting, WAF logs |

### Suggested rollout (30 / 60 / 90 days)

| Horizon | Focus |
|---------|--------|
| **30 days** | Scheduled DAST for all internet-facing prod URLs; on-call path documented |
| **60 days** | Runtime finding SLAs aligned with severity policy; first tabletop |
| **90 days** | CSPM pilot on one cloud account; attack-surface diff alerts; retro → backlog items |

---

**Navigation:** [Program overview](../appsec-program-full-circle.md) · **Previous:** [Phase 04 — Release and deploy](04-release-and-deploy.md) · **Next:** [Phase 06 — Improve and govern](06-improve-and-govern.md)
