# T1078 — Valid Accounts

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1078.003 |
| **Tactic** | Defense Evasion, Persistence, Privilege Escalation, Initial Access |
| **Simulation Date** | 2025-06-06 |
| **Status** | ⚠️ Partial |

---

## ATT&CK Description

Adversaries may obtain and abuse credentials of existing accounts as a means of gaining Initial Access, Persistence, Privilege Escalation, or Defense Evasion. Compromised credentials may be used to bypass access controls placed on various resources on systems within the network.

**Sub-technique simulated:** T1078.003 — Local Accounts

---

## Attack Objective

Log on to the Windows victim using a pre-existing valid local administrator account, simulating an adversary who has obtained credentials through prior compromise (phishing, credential dump, etc.).

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1078.003 -TestNumbers 1` |

### Test Description

Uses existing local administrator credentials to establish an interactive or network session:

```cmd
runas /user:labadmin cmd
```

Or interactive logon with known valid credentials.

### Prerequisites

- [x] Valid local account exists (`labadmin`)
- [x] Credentials known to operator (simulating prior theft)

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Security | 4624 | Successful logon |
| Security | 4648 | Explicit credential logon |
| Security | 4672 | Special privileges assigned (admin) |

### Key Fields

- `LogonType`: 2 (Interactive), 3 (Network), or 10 (RDP)
- `TargetUserName`: labadmin
- `LogonProcessName`: User32 / Advapi

### Sample Log Excerpt

```
Event ID: 4624
LogonType: 2
TargetUserName: labadmin
LogonType: Success
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100105 |
| **Level** | 6 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Detect interactive logon (Type 2/10) by local admin outside business hours
- Correlate with recent account creation (T1136) or credential dump (T1003)
- Standalone valid logon does NOT alert (by design — reduces FP)

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_valid_account_logon.yml` |
| **Product** | windows |
| **Service** | security |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ⚠️ | Logs success but no adversary-specific indicator |
| Custom Wazuh | ⚠️ | Rule 100105 — behavioral only |
| Sigma Logic | ⚠️ | Requires enrichment/correlation |

**Overall:** ⚠️ Partial

---

## Detection Gaps

- **Core gap:** Valid credential use is indistinguishable from legitimate activity in a single event
- No failed authentication preceding success (unlike brute force)
- Stolen hash pass-the-hash may not generate 4648
- Service accounts used interactively are detectable but local admin is noisy

---

## Remediation Recommendations

1. Deploy UEBA for anomalous logon behavior (new host, odd hours, impossible travel)
2. Alert on interactive logon by service accounts
3. Implement tiered admin model (PAW/jump hosts)
4. Correlate T1078 with preceding T1003 or T1110 in same timeframe
5. Enable Credential Guard and LAPS for local admin password rotation

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1078-logon.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1078-execution.png` |
| Event Log Screenshot | `screenshots/event-T1078-4624-success.png` |

---

## References

- [MITRE ATT&CK — T1078.003](https://attack.mitre.org/techniques/T1078/003/)
- [Atomic Red Team — T1078.003](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1078.003/T1078.003.md)
