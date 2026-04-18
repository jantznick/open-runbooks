# AppSec Policy Baseline — Contextual enhancement recommendations

## Purpose
This document suggests **optional** policy and practice additions beyond the [AppSec policy baseline](appsec-policy-baseline.md). Use it while tailoring the baseline for **data types, regulations, and business context**. Nothing here is mandatory unless your organization adopts it into your binding policy set.

**How to use**
- Pick the sections that match your data inventory and legal obligations.
- Turn recommendations into **MUST** / **SHOULD** / **MAY** in your own policy language.
- Map adopted items into evidence and metadata (extend `policy-evidence-mapping.yaml` or your catalog when you automate checks).
- Keep a **traceability note** (e.g. “PCI DSS Req. X — see payment data section”) in your cyber policy hierarchy.

**Disclaimer**  
These are **security and software-governance** recommendations, not legal, regulatory, or compliance advice. Engage privacy, compliance, and counsel for jurisdictional requirements (HIPAA, GDPR, PCI DSS, SOC 2, etc.).

---

## Cross-cutting themes (combine with any section below)

When you handle **sensitive** or **regulated** data in applications, consider strengthening the baseline in predictable ways:

| Theme | Recommendation |
|--------|----------------|
| **Data classification** | Require explicit **data categories** and **legal basis** (or equivalent) in application metadata—not only “we store PII.” |
| **Retention and deletion** | Add requirements for **retention schedules**, **secure deletion**, and **right-to-erasure** workflows where law or contract applies. |
| **Encryption** | Specify **encryption in transit** (TLS baseline version/ciphers) and **at rest** (key management, CMK vs provider keys) for sensitive fields. |
| **Access and segregation** | Require **role-based access**, **least privilege** for production data, and **environment separation** (no prod data in dev without controls). |
| **Logging and monitoring** | Define what **must not** be logged (secrets, full PAN, PHI content); require **audit trails** for admin and data access where required. |
| **Third parties and subprocessors** | Require **vendor security review**, **DPA** alignment, and **subprocessor inventory** for apps that send data to external services. |
| **Testing depth** | Tighten **DAST** cadence, add **authenticated scanning**, **API fuzzing**, or **periodic pen test** minimums for high-tier apps. |
| **Incident readiness** | Require **playbooks**, **notification timelines**, and **exercise cadence** aligned to your incident and breach policy. |

---

## Applications that handle general user / consumer personal data

**Context:** Names, emails, addresses, account data, usage analytics tied to identity, or other **personally identifiable information (PII)** without specialized health or payment regimes.

**Recommended additions**
- **Privacy by design:** Security requirements MUST include **data minimization**, **purpose limitation**, and **user-visible flows** (consent, preferences) where product and law require them.
- **Records of processing:** Maintain a **simple inventory** of categories of personal data, purposes, and systems per application (supports DPIA / ROPA-style needs).
- **International transfers:** If data crosses borders, document **transfer mechanism** (SCCs, adequacy, etc.) at the **application or processing-activity** level and reflect in architecture reviews.
- **Breach impact:** Classify apps by **severity of harm** if credentials or profile data are exposed; adjust **SLAs** for vulnerability remediation accordingly.
- **Child or student users:** If applicable, add **age-gating**, **parental consent**, and **restricted data processing** requirements (jurisdiction-specific).

**Evidence to consider:** Privacy impact assessment records, data-flow diagrams with PII labels, transfer records, DPIA sign-off links.

---

## Applications that handle customer health information (PHI / clinical context)

**Context:** US **HIPAA**-regulated environments, clinical systems, wellness apps that rise to medical device or covered-entity obligations, or **equivalent health privacy regimes** elsewhere. Exact scope is legal fact—this list is technical hygiene only.

**Recommended additions**
- **PHI boundaries:** Define **what constitutes PHI** in each system; prohibit **unnecessary PHI** in non-production environments or require **de-identified / synthetic** datasets for dev/test.
- **Access controls:** Strengthen **authentication** (MFA for workforce access to PHI systems), **session timeout**, and **automatic logoff**; document **break-glass** procedures.
- **Audit:** Require **audit logs** for access to PHI records (who, when, what patient context if applicable) with **tamper-evident** storage and retention per policy.
- **Integrity:** Require **integrity controls** on clinical or safety-critical data paths where alteration could harm patients.
- **BAA-aligned vendors:** Any service processing PHI on your behalf MUST be **onboarded** through a **vendor risk** path that captures BAA (or equivalent) before connection.
- **Minimum necessary:** Encode **minimum necessary** access in **RBAC** design and **API scopes**; review on major feature changes.

**Evidence to consider:** Access control matrices, audit log samples, vendor BAAs, de-identification procedures, training records for workforce.

---

## Applications that handle payment card data

**Context:** **PCI DSS** applies when you **store, process, or transmit** cardholder data. Scope reduction (tokenization, hosted fields, redirect to PSP) is the primary architectural control—policy should **reward** reduced scope.

**Recommended additions**
- **Scope documentation:** Each app MUST document whether it is **in PCI scope**, **connected to** CDE, or **out of scope** with rationale reviewed by security/compliance.
- **PAN and sensitive auth data:** **Prohibit** storage of **full track data**, **CVV** after authorization, and **PIN** except as allowed by standard; **mask** PAN in displays and logs.
- **Segmentation:** If you operate a **CDE**, require **network segmentation** and **access controls** documented in architecture; test segmentation periodically.
- **Key management:** Cryptographic keys for cardholder data MUST follow **key generation, distribution, storage, and rotation** rules aligned to PCI (or your QSA guidance).
- **ASV / scanning:** Where PCI requires **external vulnerability scans**, tie cadence and **passing** scans to **release** or **quarterly** gates explicitly in policy.
- **Change control:** Material changes to **CDE** or **card flows** require **security review** and **updated** network/data-flow diagrams before deployment.

**Evidence to consider:** PCI scope diagrams, SAQ or ROC references, segmentation test results, key custodian procedures, ASV reports linked to releases.

---

## Applications that handle banking / financial data (non-card)

**Context:** Account numbers, wires, KYC data, credit decisions, open banking APIs—often overlapping **GLBA**, **SOC 2**, or **regional open-banking** rules. Tailor to your regulator.

**Recommended additions**
- **Fraud and abuse:** Require **rate limiting**, **device binding**, **step-up authentication**, and **anomaly detection** for high-risk transactions or account changes.
- **Strong customer authentication:** Where regulation mandates **SCA**, align app auth flows and **API** protections to those requirements.
- **Immutable financial records:** Require **append-only** or **WORM**-style storage where **ledger integrity** is required; protect **admin override** with dual control.
- **API security:** For **financial APIs**, mandate **OAuth/OIDC** best practices, **mTLS** or **signed requests** where standard, and **contract testing** against abuse cases.

**Evidence to consider:** Fraud control design reviews, SCA flow diagrams, API gateway policies, change logs for ledger systems.

---

## Government, defense, or critical-infrastructure-facing systems

**Context:** **FedRAMP**, **CMMC**, **NIST 800-171/172**, **IEC 62443**, or sector-specific rules. Requirements vary widely—use this as a **prompt list**, not a checklist.

**Recommended additions**
- **Supply chain:** **SBOM** and **provenance** often move from SHOULD toward **MUST**; require **approved dependency** lists or **internal registries** for high systems.
- **Configuration hardening:** Mandate **CIS benchmarks** or **STIGs** for platforms hosting the application; **continuous configuration assessment**.
- **Segregation:** **IL5/IL6**-style separation, **air gaps**, or **diodes** where architecture demands—document in threat model and **change control**.
- **Personnel:** **Background checks**, **cleared** access, or **role-of-privilege** rules for production and key material—coordinate with HR and physical security policies.

**Evidence to consider:** SBOM artifacts, hardening baselines, POA&M-style tracking, access rosters, configuration scan results.

---

## Multi-tenant SaaS and B2B platforms

**Context:** One codebase serves **many customers**; **tenant isolation** failures are critical.

**Recommended additions**
- **Tenant isolation:** MUST define **isolation model** (DB row-level, schema-per-tenant, cluster-per-tenant) and **test** for **cross-tenant** access (automated tests + periodic review).
- **Tenant context in authZ:** Every request MUST resolve **tenant identity**; **forbid** optional tenant IDs from clients without **cryptographic** or **server-side** binding.
- **Admin / support access:** **Impersonation** or **break-glass** MUST be **logged**, **time-bound**, and **approved**; **notify** customer where contract requires.
- **Per-tenant crypto:** Where customers bring **keys** (BYOK), document **key lifecycle** and **backup/restore** responsibilities.

**Evidence to consider:** Isolation test suites, authZ design docs, impersonation audit samples, tenant onboarding runbooks.

---

## Applications using AI / ML on personal or sensitive data

**Context:** Models trained or fine-tuned on **customer data**, **prompts** containing PII, or **automated decisions** with legal effect.

**Recommended additions**
- **Training data governance:** Prohibit use of **production PII** in training without **legal basis** and **anonymization** where required; maintain **dataset provenance**.
- **Model and prompt logging:** Define **retention** and **access** for prompts, outputs, and **model versions**; **redact** where logs could re-identify individuals.
- **Human oversight:** Where **automated decisions** affect users, require **human review** paths and **appeal** hooks per product/legal design.
- **Third-party models:** API keys and **data processing** terms for **external LLM** providers MUST be **reviewed**; **block** categories of data from being sent where policy forbids.

**Evidence to consider:** Data use policies for ML, DPA addenda for AI vendors, red-team or safety review records, model cards or release notes.

---

## Adopting enhancements into your baseline

1. **Tag applications** in metadata with **data classes** and **regulatory tags** (e.g. `pci_scope`, `phi`, `gdpr_relevant`).
2. For each tag, **copy** the relevant bullets into your authoritative policy and assign **MUST/SHOULD**.
3. Update **risk tier** rubrics so high-sensitivity data **automatically** raises tier and **scan / review** requirements.
4. Add **Layer 2** evidence types for new obligations (e.g. `pci_scope_statement`, `phi_access_audit_sample`).

---

## Related documents
- [AppSec policy baseline](appsec-policy-baseline.md) — minimum AppSec controls.
- [AppSec policy baseline — minified](appsec-policy-baseline-minified.md) — requirements and actions only.
- [Policy evidence mapping](policy-evidence-mapping.yaml) — automation template.

---

*Treat this file as a living menu of enhancements; revise when regulations, standards, or your product surface area change.*
