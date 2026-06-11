# T1136 — Create Account

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1136.001 |
| **Tactic** | Persistence |
| **Simulation Date** | 2025-06-12 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may create a local account to maintain access to victim systems. Local accounts are those configured by an organization for use by users, remote support, services, or for administration on a single system or workstation.

---

## Attack Objective

Create a new local user account on the Windows victim to establish a persistence foothold with credentials controlled by the adversary.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1136.001 -TestNumbers 1` |

### Test Command

```cmd
net user eviluser EvilPass123! /add
net localgroup administrators eviluser /add
```

### Prerequisites

- [x] Administrator privileges
- [x] Windows Audit Policy: Audit Account Management enabled
- [x] Wazuh agent collecting Security log

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Security | 4720 | User account created |
| Security | 4732 | Member added to security-enabled local group |
| Security | 4722 | User account enabled |
| Sysmon | 1 | Process Creation (net.exe) |

### Key Fields (Event 4720)

- `TargetUserName`: eviluser
- `SubjectUserName`: administrator who ran command
- `SamAccountName`: eviluser

### Sample Log Excerpt

```
Event ID: 4720
TargetUserName: eviluser
TargetDomainName: WORKSTATION
SubjectUserName: labadmin
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100111 |
| **Level** | 10 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match Security Event 4720 (local account created)
- Escalate if followed by Event 4732 (added to Administrators) within 24 hours
- Exclude known provisioning service accounts if allowlisted

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_account_creation.yml` |
| **Product** | windows |
| **Service** | security |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ✅ | Rule 60103 (account added) |
| Custom Wazuh | ✅ | Rule 100111 (with admin group correlation) |
| Sigma Logic | ✅ | Event 4720 detection |

**Overall:** ✅ Full

---

## Detection Gaps

- Domain account creation (4720 on DC) vs local account — ensure correct log source
- `$` ending machine accounts may blend with AD computer accounts
- Temporary accounts created by legitimate installers

---

## Remediation Recommendations

1. Alert on any local account added to Administrators group
2. Implement LAPS; avoid shared local admin passwords
3. Restrict account management to privileged access workstations
4. Review Event 4720 weekly for unauthorized accounts
5. Disable unused local accounts via GPO baseline

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1136-account-creation.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1136-execution.png` |
| Event Log Screenshot | `screenshots/event-T1136-4720.png` |

---

## References

- [MITRE ATT&CK — T1136.001](https://attack.mitre.org/techniques/T1136/001/)
- [Atomic Red Team — T1136.001](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1136.001/T1136.001.md)
