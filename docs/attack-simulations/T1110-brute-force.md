# T1110 — Brute Force

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1110.003 (Password Spraying) |
| **Tactic** | Credential Access |
| **Simulation Date** | 2025-06-01 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may use brute force techniques to gain access to accounts when passwords are unknown or when password hashes are obtained. Without knowledge of the password for an account or set of accounts, an adversary may systematically guess the password using a repetitive or iterative mechanism. Brute force attacks can target single sign-on (SSO), cloud-based applications, and other services.

**Sub-technique simulated:** T1110.003 — Password Spraying

---

## Attack Objective

Simulate an adversary attempting multiple authentication failures against a local Windows account to identify valid credentials or trigger account lockout. In this lab, the goal is to generate clustered Event 4625 (failed logon) entries detectable by threshold-based SIEM rules.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test GUID** | Varies by ART version |
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1110.003 -TestNumbers 1` |

### Lab Execution (Windows-adapted)

```powershell
# Simulate failed logons (lab-safe)
1..6 | ForEach-Object {
    cmd /c "net use \\localhost\IPC$ /user:labuser WrongPass$_" 2>$null
    Start-Sleep -Seconds 2
}
```

### Prerequisites

- [x] Wazuh agent active on Windows 10 victim
- [x] Windows Audit Policy: Audit Logon Failures enabled
- [x] Test account `labuser` exists (no lockout policy or threshold set high for lab)

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Security | 4625 | An account failed to log on |
| Security | 4776 | Credential validation failed (NTLM) |

### Key Fields (Event 4625)

- `TargetUserName`: labuser
- `FailureReason`: Unknown user name or bad password (0xC000006D)
- `LogonType`: 3 (Network)
- `IpAddress`: 127.0.0.1 or attacker IP

### Sample Log Excerpt

```
Event ID: 4625
TargetUserName: labuser
Status: 0xC000006D
SubStatus: 0xC000006A
LogonType: 3
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100100 |
| **Level** | 10 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Parent rule: Windows failed logon (built-in 60122)
- Custom rule fires when **5 or more** Event 4625 occurrences from the same `srcip` within **60 seconds**
- MITRE tag: T1110

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_security_brute_force.yml` |
| **Product** | windows |
| **Service** | security |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ✅ | Rule 60122 (failed logon) |
| Custom Wazuh | ✅ | Rule 100100 (threshold) |
| Sigma Logic | ✅ | Frequency aggregation |

**Overall:** ✅ Full

---

## Detection Gaps

- Distributed password spraying across many IPs evades single-source threshold
- Low-and-slow attempts (1 failure/hour) bypass frequency rules
- Cloud SSO brute force not covered by Windows Security logs

---

## Remediation Recommendations

1. Enable account lockout policy with reasonable threshold (5 attempts / 15 min)
2. Deploy multi-source correlation (same username, multiple source IPs)
3. Implement MFA for all interactive logons
4. Monitor Event 4740 (account lockout) as secondary indicator

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1110-brute-force.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1110-execution.png` |
| Event Log Screenshot | `screenshots/event-T1110-4625-failures.png` |

---

## References

- [MITRE ATT&CK — T1110](https://attack.mitre.org/techniques/T1110/)
- [MITRE ATT&CK — T1110.003](https://attack.mitre.org/techniques/T1110/003/)
- [Atomic Red Team — T1110.003](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1110.003/T1110.003.md)
