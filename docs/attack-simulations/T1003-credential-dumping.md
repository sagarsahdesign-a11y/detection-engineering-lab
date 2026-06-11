# T1003 — OS Credential Dumping

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1003.001 |
| **Tactic** | Credential Access |
| **Simulation Date** | 2025-06-04 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may attempt to access credential material stored in the process memory of the Local Security Authority Subsystem Service (LSASS). After a user logs on, the system generates and stores a variety of credential materials in LSASS process memory. These credentials can be harvested by an adversary with administrative privileges.

---

## Attack Objective

Simulate credential dumping by accessing LSASS process memory using ProcDump (Sysinternals), a common living-off-the-land technique used before deploying Mimikatz.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1003.001 -TestNumbers 1` |

### Test Description

Downloads ProcDump and dumps LSASS memory:

```cmd
procdump.exe -accepteula -ma lsass.exe lsass_dump.dmp
```

### Prerequisites

- [x] Sysmon installed with Event 10 (ProcessAccess) enabled
- [x] Administrator privileges on victim
- [x] Wazuh agent collecting Sysmon Operational log

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Sysmon | 10 | Process Access (target: lsass.exe) |
| Sysmon | 1 | Process Creation (procdump.exe) |
| Security | 4688 | Process creation (if audited) |

### Key Fields (Sysmon Event 10)

- `TargetImage`: `C:\Windows\System32\lsass.exe`
- `SourceImage`: path to procdump.exe or suspicious process
- `GrantedAccess`: 0x1010, 0x1410, 0x143A (common dump access masks)

### Sample Log Excerpt

```
Event ID: 10
SourceImage: C:\Tools\procdump.exe
TargetImage: C:\Windows\System32\lsass.exe
GrantedAccess: 0x1410
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100103 |
| **Level** | 14 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match Sysmon Event 10 where `TargetImage` contains `lsass.exe`
- Exclude known legitimate sources (e.g., `C:\Windows\System32\wbem\WmiPrvSE.exe` with limited access)
- High severity — credential theft indicator

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_lsass_access.yml` |
| **Product** | windows |
| **Service** | sysmon |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ⚠️ | Some Sysmon rules exist |
| Custom Wazuh | ✅ | Rule 100103 |
| Sigma Logic | ✅ | Industry-standard LSASS rule |

**Overall:** ✅ Full

---

## Detection Gaps

- `comsvcs.dll` MiniDump via rundll32 may not match all LSASS access patterns
- Direct syscall / handle duplication techniques
- Offline dump analysis not detectable after exfiltration
- Kernel drivers (e.g., custom tools) bypass user-mode Sysmon

---

## Remediation Recommendations

1. Enable Windows Defender Credential Guard
2. Restrict debug privileges (SeDebugPrivilege) to authorized accounts
3. Deploy Sysmon with ProcessAccess monitoring for lsass.exe
4. Add rule for `rundll32.exe comsvcs.dll,#24` MiniDump pattern
5. Implement LSA protection (RunAsPPL) on Windows 10+

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1003-lsass-access.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1003-execution.png` |
| Event Log Screenshot | `screenshots/event-T1003-sysmon10.png` |

---

## References

- [MITRE ATT&CK — T1003.001](https://attack.mitre.org/techniques/T1003/001/)
- [Atomic Red Team — T1003.001](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1003.001/T1003.001.md)
