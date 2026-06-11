# TXXXX — [Technique Name]

| Field | Value |
|-------|-------|
| **ATT&CK ID** | TXXXX |
| **Tactic** | [Tactic Name] |
| **Simulation Date** | YYYY-MM-DD |
| **Status** | ✅ Detected / ⚠️ Partial / ❌ Not Detected |

---

## ATT&CK Description

[Copy official MITRE ATT&CK technique description from https://attack.mitre.org/techniques/TXXXX/]

---

## Attack Objective

[What the adversary is trying to accomplish with this technique in your simulation context.]

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test GUID** | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| **Test Number** | N |
| **Command** | `Invoke-AtomicTest TXXXX -TestNumbers N` |

### Execution Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

### Prerequisites

- [ ] Wazuh agent active
- [ ] [Any technique-specific prerequisites]

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| [Source] | [ID] | [What to look for] |

### Sample Log Excerpt

```
[Paste sanitized log sample]
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 1001XX |
| **Level** | X |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

[Describe match conditions: fields, regex, thresholds]

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_[name].yml` |
| **Product** | windows |
| **Service** | [security / sysmon / powershell] |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ✅ / ⚠️ / ❌ | |
| Custom Wazuh | ✅ / ⚠️ / ❌ | |
| Sigma Logic | ✅ / ⚠️ / ❌ | |

**Overall:** ✅ Full / ⚠️ Partial / ❌ None

---

## Detection Gaps

- [Gap 1]
- [Gap 2]

---

## Remediation Recommendations

1. [Recommendation 1]
2. [Recommendation 2]

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-TXXXX-[name].png` |
| Atomic Execution Screenshot | `screenshots/atomic-TXXXX-execution.png` |
| Event Log Screenshot | `screenshots/event-TXXXX-[eventid].png` |

---

## References

- [MITRE ATT&CK — TXXXX](https://attack.mitre.org/techniques/TXXXX/)
- [Atomic Red Team — TXXXX](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/TXXXX/TXXXX.md)
