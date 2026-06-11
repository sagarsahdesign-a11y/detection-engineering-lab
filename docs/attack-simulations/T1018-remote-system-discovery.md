# T1018 — Remote System Discovery

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1018 |
| **Tactic** | Discovery |
| **Simulation Date** | 2025-06-09 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may attempt to get a listing of other systems by IP address, hostname, or other logical identifier on a network. Adversaries may use this information to shape follow-on behaviors, including whether or not to fully infect the target and/or attempt specific actions.

---

## Attack Objective

Enumerate remote systems on the network using `net view`, `nltest`, and DNS queries, simulating adversary reconnaissance before lateral movement.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1018 -TestNumbers 1` |

### Test Commands

```cmd
net view
net view /domain
nltest /dclist:
nslookup internal-host
```

### Prerequisites

- [x] Process creation logging enabled
- [x] Lab network with multiple VMs (optional, for realistic output)

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Sysmon | 1 | Process Creation (net.exe, nltest.exe, nslookup.exe) |
| Sysmon | 3 | Network Connection (LDAP, DNS, SMB) |
| Security | 4688 | Process creation (if audited) |

### Key Indicators

- `net view`, `net group "Domain Computers"`
- `nltest /dclist`
- `ping -n 1` sweep patterns

### Sample Log Excerpt

```
Event ID: 1 (Sysmon)
Image: C:\Windows\System32\net.exe
CommandLine: net view
ParentImage: C:\Windows\System32\cmd.exe
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100108 |
| **Level** | 8 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match `net.exe` with `view` or `group` arguments
- Match `nltest.exe` with `/dclist` or `/dsgetdc`
- Exclude domain controllers and management server hostnames

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_remote_system_discovery.yml` |
| **Product** | windows |
| **Service** | sysmon |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ⚠️ | Limited net.exe rules |
| Custom Wazuh | ✅ | Rule 100108 |
| Sigma Logic | ✅ | net view / nltest patterns |

**Overall:** ✅ Full

---

## Detection Gaps

- PowerShell equivalents (`Get-ADComputer`) not matched by net.exe rules
- Domain-joined workstations running `net view` during troubleshooting
- Ping sweeps via third-party tools (nmap) from Kali not on victim logs

---

## Remediation Recommendations

1. Allowlist IT management servers running legitimate inventory
2. Alert when discovery commands originate from user workstations (non-IT)
3. Monitor for `net view` followed by `mstsc` or `wmic` within 30 minutes
4. Collect network flow data for internal scanning detection

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1018-net-view.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1018-execution.png` |
| Event Log Screenshot | `screenshots/event-T1018-process-create.png` |

---

## References

- [MITRE ATT&CK — T1018](https://attack.mitre.org/techniques/T1018/)
- [Atomic Red Team — T1018](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1018/T1018.md)
