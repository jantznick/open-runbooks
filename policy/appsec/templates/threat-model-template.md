# Threat model templates

Choose the format that fits how you work. **For application inventory / catalog and simple web forms, use catalog lite** — not Threat Dragon.

| Template | Best for | Catalog / form |
|----------|----------|----------------|
| **[threat-model-catalog-lite.md](threat-model-catalog-lite.md)** | Inventory, catalog UI, basic web form, JSON storage | **Yes — start here** |
| **[threat-model-catalog-schema.yaml](threat-model-catalog-schema.yaml)** | Developers implementing the catalog form or API | Field types, enums, validation |
| **[threat-model-template-full.md](threat-model-template-full.md)** | Complex systems, optional diagrams, per-component STRIDE | Optional; link via `diagram_url` |

**Policy:** Control **B2** — [policy baseline](../framework/appsec-policy-baseline.md). **When required:** internet-facing or `risk_tier` medium/high (unless org says otherwise).

**Evidence:** Approved catalog lite (or full) record = `threat_model_document` per [`policy-evidence-mapping.yaml`](../framework/policy-evidence-mapping.yaml).
