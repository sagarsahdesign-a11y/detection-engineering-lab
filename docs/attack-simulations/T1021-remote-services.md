# T1021 — Remote Services

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1021.001 |
| **Tactic** | Lateral Movement |
| **Simulation Date** | 2025-06-05 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may use Valid Accounts to log into a computer using the Remote Desktop Protocol (RDP). The adversary may then perform actions as the logged-on user. Remote desktop is a common feature in operating systems that allows a user to log into an interactive session on a remote system.

---

## Attack Objective

Simulate lateral movement by establishing an RDP session from a Kali Linux attacker VM (or second Windows host) to the Windows 10 victim, generating interactive remote logon events.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1021.001 -TestNumbers 1` |

### Lab Execution

```bash
# From Kali Linux attacker
xfreerdp /v:192.168.56.20 /u:labadmin /p:'LabPass123!' /cert:ignore
```

Or enable RDP and connect from a second Windows VM.

### Prerequisites

- [x] RDP enabled on Windows victim
- [x] Valid credentials for test account
- [x] Network connectivity between attacker and victim VMs

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Security | 4624 | Successful logon (Logon Type 10) |
| Security | 4634 / 4647 | Logoff events |
| TerminalServices-LocalSessionManager | 21 | Session logon succeeded |
| TerminalServices-LocalSessionManager | 25 | Session reconnection |

### Key Fields (Event 4624)

- `LogonType`: 10 (RemoteInteractive)
- `IpAddress`: attacker VM IP (e.g., 192.168.56.30)
- `AuthenticationPackage`: Negotiate / NTLM / Kerberos

### Sample Log Excerpt

```
Event ID: 4624
LogonType: 10
TargetUserName: labadmin
IpAddress: 192.168.56.30
WorkstationName: KALI-ATTACKER
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100104 |
| **Level** | 8 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match Event 4624 with LogonType 10 (RDP)
- Alert when source IP is outside defined admin jump host range
- Correlate with first-time logon from new source IP

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_rdp_logon.yml` |
| **Product** | windows |
| **Service** | security |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ✅ | Rule 67017 (RDP logon) |
| Custom Wazuh | ✅ | Rule 100104 (geo/source tuning) |
| Sigma Logic | ✅ | LogonType 10 detection |

**Overall:** ✅ Full

---

## Detection Gaps

- Legitimate IT admin RDP sessions create false positives
- RDP over VPN/tunnel may obscure true source IP
- Pass-the-hash RDP without explicit credential entry

---

## Remediation Recommendations

1. Restrict RDP to jump servers/bastion hosts only
2. Enable Network Level Authentication (NLA)
3. Implement MFA for RDP via Azure AD or RD Gateway
4. Allowlist known admin source IPs; alert on all others
5. Disable RDP on workstations where not required

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1021-rdp-logon.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1021-execution.png` |
| Event Log Screenshot | `screenshots/event-T1021-4624-type10.png` |

---

## References

- [MITRE ATT&CK — T1021.001](https://attack.mitre.org/techniques/T1021/001/)
- [Atomic Red Team — T1021.001](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1021.001/T1021.001.md)
