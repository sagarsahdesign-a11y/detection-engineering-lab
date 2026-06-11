# Detection Rule Template

Use this template when authoring new detection rules for the lab.

---

## Rule Metadata

| Field | Value |
|-------|-------|
| **Rule Name** | |
| **ATT&CK Technique** | TXXXX — [Name] |
| **Author** | |
| **Created** | YYYY-MM-DD |
| **Last Updated** | YYYY-MM-DD |
| **Status** | Draft / Testing / Production |
| **Severity** | Low / Medium / High / Critical |

---

## Threat Context

### Technique Description

[Why this technique matters and when adversaries use it.]

### Attack Scenario

[Describe the attack chain step this rule detects.]

---

## Data Requirements

| Log Source | Event ID(s) | Required Fields |
|------------|-------------|-----------------|
| | | |

### Telemetry Prerequisites

- [ ] Log source enabled
- [ ] Audit policy configured
- [ ] Sysmon installed (if applicable)

---

## Detection Logic

### Hypothesis

> If [condition], then [adversary behavior] is likely occurring.

### Logic (Pseudo-code)

```
IF event_id == XXXX
AND field contains "pattern"
AND NOT source in allowlist
THEN alert(severity=high)
```

### False Positive Considerations

| Known FP Source | Tuning Action |
|-----------------|---------------|
| | |

---

## Sigma Rule

```yaml
title: 
id: 
status: experimental
description: 
references:
    - https://attack.mitre.org/techniques/TXXXX/
author: 
date: YYYY/MM/DD
tags:
    - attack.txxxx
logsource:
    product: windows
    service: 
detection:
    selection:
    condition: selection
falsepositives:
    - 
level: high
```

**File path:** `sigma-rules/win_[descriptive_name].yml`

---

## Wazuh Rule

```xml
<rule id="1001XX" level="10">
  <description>[Rule description]</description>
  <!-- match conditions -->
  <mitre>
    <id>TXXXX</id>
  </mitre>
</rule>
```

**File path:** `custom-rules/local_rules.xml`

---

## Testing

### Atomic Red Team Test

```powershell
Invoke-AtomicTest TXXXX -TestNumbers N
```

### Test Results

| Test Run | Date | Alert Fired | Rule ID | Notes |
|----------|------|-------------|---------|-------|
| 1 | | ✅ / ❌ | | |

---

## Tuning Log

| Date | Change | Reason |
|------|--------|--------|
| | | |

---

## References

- MITRE ATT&CK:
- Atomic Red Team:
- Related Rules:
