# Atomic Red Team Test Mapping

Reference table linking MITRE ATT&CK techniques to Atomic Red Team tests used in this lab.

---

## Quick Reference

| # | ATT&CK ID | Technique | ART Test # | Invoke Command |
|---|-----------|-----------|------------|----------------|
| 1 | T1110.003 | Password Spraying | 1 | `Invoke-AtomicTest T1110.003 -TestNumbers 1` |
| 2 | T1059.001 | PowerShell | 1 | `Invoke-AtomicTest T1059.001 -TestNumbers 1` |
| 3 | T1547.001 | Registry Run Keys | 1 | `Invoke-AtomicTest T1547.001 -TestNumbers 1` |
| 4 | T1003.001 | LSASS Memory | 1 | `Invoke-AtomicTest T1003.001 -TestNumbers 1` |
| 5 | T1021.001 | Remote Desktop Protocol | 1 | `Invoke-AtomicTest T1021.001 -TestNumbers 1` |
| 6 | T1078.003 | Local Accounts | 1 | `Invoke-AtomicTest T1078.003 -TestNumbers 1` |
| 7 | T1105 | Ingress Tool Transfer | 1 | `Invoke-AtomicTest T1105 -TestNumbers 1` |
| 8 | T1082 | System Information Discovery | 1 | `Invoke-AtomicTest T1082 -TestNumbers 1` |
| 9 | T1018 | Remote System Discovery | 1 | `Invoke-AtomicTest T1018 -TestNumbers 1` |
| 10 | T1047 | Windows Management Instrumentation | 1 | `Invoke-AtomicTest T1047 -TestNumbers 1` |
| 11 | T1055.001 | Dynamic-link Library Injection | 1 | `Invoke-AtomicTest T1055.001 -TestNumbers 1` |
| 12 | T1136.001 | Local Account | 1 | `Invoke-AtomicTest T1136.001 -TestNumbers 1` |

---

## Detailed Test Descriptions

### T1110.003 — Password Spraying

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1110.003/T1110.003.md` |
| **Test Name** | Password Spray via SSH (adapted for Windows logon failures in lab) |
| **Lab Adaptation** | Windows: multiple failed logons via `runas` or `net use` with bad passwords |
| **Expected Outcome** | Multiple Event 4625 within short window |

### T1059.001 — PowerShell

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1059.001/T1059.001.md` |
| **Test Name** | Mimikatz in PowerShell |
| **Description** | Downloads and reflects mimikatz or executes encoded PowerShell |
| **Expected Outcome** | PowerShell 4104 + suspicious process creation |

### T1547.001 — Registry Run Keys

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1547.001/T1547.001.md` |
| **Test Name** | Reg Add Run key |
| **Description** | Adds persistence via `HKCU\Software\Microsoft\Windows\CurrentVersion\Run` |
| **Expected Outcome** | Registry modification + process at logon |

### T1003.001 — LSASS Memory

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1003.001/T1003.001.md` |
| **Test Name** | Dump LSASS.exe memory using ProcDump |
| **Description** | Uses Sysinternals ProcDump to dump LSASS |
| **Expected Outcome** | Sysmon Event 10 targeting lsass.exe |

### T1021.001 — Remote Desktop Protocol

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1021.001/T1021.001.md` |
| **Test Name** | RDP to Domain Controller |
| **Lab Adaptation** | RDP from Kali/attacker VM to Windows victim |
| **Expected Outcome** | Event 4624 Logon Type 10 |

### T1078.003 — Local Accounts

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1078.003/T1078.003.md` |
| **Test Name** | Valid Accounts — Local Administrator |
| **Description** | Logon using existing local admin credentials |
| **Expected Outcome** | Event 4624 success (hard to distinguish from legit) |

### T1105 — Ingress Tool Transfer

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1105/T1105.md` |
| **Test Name** | certutil download |
| **Description** | `certutil -urlcache -split -f http://...` |
| **Expected Outcome** | certutil process + file written to disk |

### T1082 — System Information Discovery

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1082/T1082.md` |
| **Test Name** | Windows — Discover OS version |
| **Description** | Runs `systeminfo`, `hostname`, `whoami` |
| **Expected Outcome** | Multiple process creation events |

### T1018 — Remote System Discovery

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1018/T1018.md` |
| **Test Name** | Remote System Discovery — net view |
| **Description** | `net view`, `net group "Domain Computers"` |
| **Expected Outcome** | Process creation with net.exe arguments |

### T1047 — WMI

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1047/T1047.md` |
| **Test Name** | WMI Reconnaissance |
| **Description** | `wmic process call create` or `Get-WmiObject` queries |
| **Expected Outcome** | WmiPrvSE.exe child processes |

### T1055.001 — DLL Injection

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1055.001/T1055.001.md` |
| **Test Name** | DLL Injection via PowerShell |
| **Description** | Injects DLL into remote process |
| **Expected Outcome** | Sysmon Event 8 CreateRemoteThread |

### T1136.001 — Local Account

| Field | Value |
|-------|-------|
| **Atomic Path** | `atomics/T1136.001/T1136.001.md` |
| **Test Name** | Create local user account |
| **Description** | `net user eviluser EvilPass123 /add` |
| **Expected Outcome** | Event 4720 account created |

---

## Installation

```powershell
# Install Invoke-AtomicRedTeam module
Install-Module -Name invoke-atomicredteam -Scope CurrentUser

# Import module
Import-Module invoke-atomicredteam

# List available tests for a technique
Get-AtomicTest T1003.001

# Execute with pre-checks
Invoke-AtomicTest T1003.001 -TestNumbers 1 -CheckPrereqs
Invoke-AtomicTest T1003.001 -TestNumbers 1
```

---

## Lab Safety Checklist

- [ ] VM snapshot taken before execution
- [ ] Isolated network (no production access)
- [ ] Wazuh agent confirmed active
- [ ] Atomic cleanup executed where available: `Invoke-AtomicTest TXXXX -TestNumbers N -Cleanup`
- [ ] Results documented in `docs/attack-simulations/`

---

## Related Files

- [Attack Simulations](../docs/attack-simulations/)
- [MITRE Mapping](../docs/mitre-attack-mapping.md)
- [Detection Gap Analysis](../reports/detection-gap-analysis.md)
