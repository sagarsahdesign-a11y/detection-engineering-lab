# T1055 — Process Injection

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1055.001 |
| **Tactic** | Defense Evasion, Privilege Escalation |
| **Simulation Date** | 2025-06-11 |
| **Status** | ⚠️ Partial |

---

## ATT&CK Description

Adversaries may inject dynamic-link libraries (DLLs) into processes in order to evade process-based defenses as well as possibly elevate privileges. DLL injection is a method of executing arbitrary code in the address space of a separate live process.

---

## Attack Objective

Inject a DLL into a remote process using PowerShell/Atomic test tooling, simulating malware evading process-based detection by running code inside a legitimate process (e.g., explorer.exe, svchost.exe).

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1055.001 -TestNumbers 1` |

### Test Description

Uses PowerShell to inject a DLL into a target process via `CreateRemoteThread` or similar API calls.

### Prerequisites

- [x] Sysmon installed with **Event ID 8** (CreateRemoteThread) enabled
- [x] Administrator privileges
- [x] SwiftOnSecurity or custom Sysmon config including Event 8

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Sysmon | 8 | CreateRemoteThread |
| Sysmon | 7 | Image Loaded (DLL) |
| Sysmon | 10 | Process Access |
| Sysmon | 1 | Process Creation |

### Key Fields (Sysmon Event 8)

- `SourceImage`: injecting process
- `TargetImage`: victim process (e.g., notepad.exe)
- `StartModule`: ntdll.dll
- `StartFunction`: LoadLibrary or NtCreateThreadEx

### Sample Log Excerpt

```
Event ID: 8
SourceImage: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
TargetImage: C:\Windows\System32\notepad.exe
StartModule: C:\Windows\System32\kernel32.dll
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100110 |
| **Level** | 12 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match Sysmon Event 8 (CreateRemoteThread)
- Alert when source is scripting interpreter (powershell, wscript, cscript) targeting unrelated process
- Supplement with Event 7 for unsigned DLL loads

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_process_injection.yml` |
| **Product** | windows |
| **Service** | sysmon |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ⚠️ | Sysmon 8 rules exist if events collected |
| Custom Wazuh | ⚠️ | Rule 100110 — depends on Event 8 |
| Sigma Logic | ✅ | CreateRemoteThread detection |

**Overall:** ⚠️ Partial

---

## Detection Gaps

- **Primary gap:** Default Sysmon configs often omit Event ID 8
- Process hollowing and APC injection may not generate CreateRemoteThread
- Kernel-level injection invisible to user-mode Sysmon
- Some security products legitimately inject DLLs (FP risk)

---

## Remediation Recommendations

1. Deploy Sysmon config with Event 8 enabled (SwiftOnSecurity baseline)
2. Deploy EDR with kernel callback monitoring
3. Enable Attack Surface Reduction rule for code injection
4. Monitor Event 7 for DLL loads into unexpected processes
5. Restrict SeDebugPrivilege assignment

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1055-injection.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1055-execution.png` |
| Event Log Screenshot | `screenshots/event-T1055-sysmon8.png` |

---

## References

- [MITRE ATT&CK — T1055.001](https://attack.mitre.org/techniques/T1055/001/)
- [Atomic Red Team — T1055.001](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1055.001/T1055.001.md)
