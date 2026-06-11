# Incident Report Template

Use this template when documenting a validated detection from the lab as a simulated incident.

---

## Incident Summary

| Field | Value |
|-------|-------|
| **Incident ID** | LAB-YYYY-NNN |
| **Report Date** | YYYY-MM-DD |
| **Analyst** | |
| **Severity** | Low / Medium / High / Critical |
| **Status** | Simulated / Closed |
| **ATT&CK Technique** | TXXXX — [Name] |

---

## Executive Summary

[2–3 sentences describing what was detected, on which host, and the simulated impact.]

---

## Timeline

| Time (UTC) | Event | Source |
|------------|-------|--------|
| HH:MM | Atomic test executed | Lab operator |
| HH:MM | [Process/logon/etc.] observed | Event ID XXXX |
| HH:MM | Wazuh alert triggered | Rule 1001XX |
| HH:MM | Analyst validated | Wazuh Dashboard |

---

## Affected Assets

| Hostname | IP | Role | OS |
|----------|-----|------|-----|
| | | Victim | Windows 10 |

---

## Detection Details

### Alert Information

| Field | Value |
|-------|-------|
| **Wazuh Rule ID** | |
| **Alert Level** | |
| **Rule Description** | |
| **Full Log** | [Sanitized excerpt] |

### Supporting Evidence

- [ ] Wazuh alert screenshot
- [ ] Windows Event Viewer log
- [ ] Atomic Red Team execution output

---

## ATT&CK Mapping

| Tactic | Technique | Procedure |
|--------|-----------|-----------|
| | TXXXX | [What the attacker did in this simulation] |

---

## Root Cause (Simulated)

[Describe how the attack was executed in the lab — e.g., "Operator ran Invoke-AtomicTest T1003.001 simulating LSASS credential dump."]

---

## Impact Assessment

| Category | Impact | Notes |
|----------|--------|-------|
| Confidentiality | None / Low / High | |
| Integrity | None / Low / High | |
| Availability | None / Low / High | |

*Lab simulation — no real production impact.*

---

## Response Actions Taken

| Action | Status | Timestamp |
|--------|--------|-----------|
| Alert triaged in Wazuh Dashboard | Complete | |
| Event logs reviewed | Complete | |
| VM snapshot restored | Complete | |
| Detection rule validated | Complete | |

---

## Recommendations

1. [Detection improvement]
2. [Telemetry improvement]
3. [Hardening recommendation]

---

## Lessons Learned

- [What worked well in detection]
- [What gaps were identified]
- [What to test next]

---

## Appendices

- A: Full alert JSON
- B: Relevant Sigma rule (`sigma-rules/...`)
- C: Custom Wazuh rule (`custom-rules/local_rules.xml`)
- D: Screenshots (`screenshots/...`)

---

## References

- Attack simulation doc: `docs/attack-simulations/TXXXX-[name].md`
- Gap analysis: `reports/detection-gap-analysis.md`
