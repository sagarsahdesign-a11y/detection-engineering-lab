# T1082 — System Information Discovery

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1082 |
| **Tactic** | Discovery |
| **Simulation Date** | 2025-06-08 |
| **Status** | ⚠️ Partial |

---

## ATT&CK Description

An adversary may attempt to get detailed information about the operating system and hardware, including version, patches, hotfixes, service packs, and architecture. Adversaries may use this information to shape follow-on behaviors, including whether or not the adversary fully infects the target and/or attempts specific actions.

---

## Attack Objective

Enumerate host operating system version, hostname, and user context using built-in Windows commands, simulating post-compromise reconnaissance before lateral movement.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1082 -TestNumbers 1` |

### Test Commands

```cmd
hostname
whoami
systeminfo
wmic os get Caption,Version
```

### Prerequisites

- [x] Process creation logging (Sysmon Event 1 or 4688)
- [x] Wazuh agent active

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Sysmon | 1 | Process Creation |
| Security | 4688 | Process creation (if audited) |

### Key Indicators

- `systeminfo.exe`, `hostname.exe`, `whoami.exe` execution
- WMIC queries for OS information
- Multiple discovery commands in short succession

### Sample Log Excerpt

```
Event ID: 1 (Sysmon)
Image: C:\Windows\System32\systeminfo.exe
ParentImage: C:\Windows\System32\cmd.exe
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100107 |
| **Level** | 6 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- **Chain detection:** 3 or more discovery binaries within 5 minutes from same user/session
- Monitored binaries: `systeminfo`, `hostname`, `whoami`, `ipconfig`, `wmic`
- Single command execution suppressed to reduce false positives

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_system_info_discovery.yml` |
| **Product** | windows |
| **Service** | sysmon |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ❌ | No default discovery chain rule |
| Custom Wazuh | ⚠️ | Rule 100107 — chain only |
| Sigma Logic | ⚠️ | Single-command rule exists but noisy |

**Overall:** ⚠️ Partial

---

## Detection Gaps

- Individual discovery commands are used daily by admins and scripts
- PowerShell equivalents (`Get-ComputerInfo`) may not match binary names
- Automated inventory tools (SCCM) trigger same patterns
- No alert on single `whoami` — by design

---

## Remediation Recommendations

1. Correlate discovery chains with subsequent credential access or lateral movement
2. Alert when discovery commands run from unusual parent processes (Word, Excel)
3. Baseline expected discovery from management servers
4. Deploy parent-child process analytics (Office → cmd → systeminfo)

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1082-discovery-chain.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1082-execution.png` |
| Event Log Screenshot | `screenshots/event-T1082-process-create.png` |

---

## References

- [MITRE ATT&CK — T1082](https://attack.mitre.org/techniques/T1082/)
- [Atomic Red Team — T1082](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1082/T1082.md)
