# Release security sign-off (template)

**Purpose:** Confirm release security evidence before production promotion. Aligns with [Release security evidence](../framework/appsec-policy-baseline.md) (`AS-REL-001`: `release_security_bundle`, `artifact_links`).

**When:** Every **production release** (or your defined release type). Attach completed checklist to the change record, release ticket, or deployment system.

---

## Release identification

| Field | Value |
|-------|--------|
| Application `app_id` / name | |
| `risk_tier` | |
| `internet_facing` | Yes / No |
| Release version / tag | |
| Build ID / commit SHA | |
| Target environment | Production / Other: ______ |
| Release date (planned) | |
| Engineering owner | |
| Change ticket / release record link | |

---

## Scope of change

**Summary:**

**High-impact?** (auth, data handling, trust boundary, public exposure) Yes / No

**Threat model / design review for this scope:**

- [ ] Not required for this release  
- [ ] Approved — link:  
- [ ] N/A — no material security scope change  

---

## CI security evidence (required)

Attach links or artifact IDs from the build that will be deployed.

| Control | Required for this app? | Job / pipeline link | Result (Pass / Fail / Waived) | Artifact link | Date |
|---------|------------------------|---------------------|-------------------------------|---------------|------|
| SAST | Yes | | | | |
| Secrets scan | Yes | | | | |
| SCA | Yes | | | | |
| Baseline DAST | If internet-facing | | | | |
| Severity gates enforced | Yes | | | | |

**Waived failures:** List only with active, non-expired exception — ID and expiry:

| Exception ID | Control | Expiry | Approver |
|--------------|---------|--------|----------|
| | | | |

---

## Optional / profile-based evidence (SHOULD)

| Control | Applicable? | Evidence link | Notes |
|---------|-------------|---------------|-------|
| Container / image scan | | | |
| IaC / manifest scan | | | |
| SBOM (SPDX / CycloneDX) | | | |
| Provenance / attestation | | | |

---

## Open security work

| Finding ID | Severity | In scope for this release? | Disposition (Fix / Defer / Exception) | Ticket |
|------------|----------|----------------------------|----------------------------------------|--------|
| | | | | |

**Blockers for release:** None, or list Critical/High items that must be fixed or excepted:

---

## Exception validity

- [ ] No expired exceptions relied on for this release  
- [ ] All waivers documented in table above  

---

## Sign-off

| Role | Name | Date | Sign-off (Go / No-go) |
|------|------|------|------------------------|
| Release engineer / deployer | | | |
| Engineering owner | | | |
| AppSec (required for `high` tier or regulated — customize) | | | |
| Business owner (if residual risk accepted) | | | |

**No-go reason (if applicable):**

---

## Post-release

- [ ] Release record updated with this checklist and artifact links  
- [ ] Scheduled re-scan queued (if internet-facing)  
- [ ] Registry metadata current (`release_version`, evidence URLs)  

**Retention:** Keep bundle per policy — minimum **1 year** for release security evidence (customize per compliance).
