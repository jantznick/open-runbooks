# AppSec Program: 05 Runtime and Operate

## Objective
Continuously detect exposure and security drift in deployed environments and respond quickly.

## OWASP SAMM Mapping
- Primary SAMM function:
  - Operations
- Primary SAMM practices:
  - Operations: Incident Management, Environment Management, Operational Management
- Secondary SAMM practices:
  - Governance: Strategy and Metrics
  - Verification: Security Testing

## Scope
- Internet-facing services and APIs
- Cloud/Kubernetes runtime posture
- Incident detection and response workflows

## Core Activities
- External attack surface monitoring
- Periodic runtime vulnerability and misconfig scans
- Alert triage and incident response playbooks
- Re-scan cadence tied to risk and change frequency

## Suggested Tooling (Roadmap)
- External scanning: scheduled ZAP/Nuclei profiles, attack surface tooling
- Cloud posture: CSPM/KSPM tools
- Runtime detection: SIEM + alert routing
- Case handling: incident/ticket platform with runbook links

## Minimum Viable Process
- Weekly/biweekly scheduled scans for critical services
- On-call ownership for security alerts
- Incident workflow with severity and escalation paths

## Common Pitfalls
- Great CI security but no runtime monitoring
- Alert volume without triage process
- No closure loop from incidents back into preventive controls

## Inputs
- Deployed endpoints and environment inventory
- Current risk ratings and ownership mapping

## Outputs
- Runtime findings and incidents
- Time-bounded remediation tasks
- Post-incident lessons and control updates

## Success Metrics
- MTTD/MTTR for security incidents
- % critical runtime findings remediated within SLA
- Reduction of recurring incident classes

## Next Related Step
- `runbooks/appsec/program/06-improve-and-govern.md`
