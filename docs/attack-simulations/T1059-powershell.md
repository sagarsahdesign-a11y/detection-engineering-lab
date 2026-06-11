# T1059 — Command and Scripting Interpreter: PowerShell

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1059.001 |
| **Tactic** | Execution |
| **Simulation Date** | 2025-06-02 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may abuse PowerShell commands and scripts for execution. PowerShell is a powerful interactive command-line interface and scripting environment included in the Windows operating system. Adversaries can use PowerShell to perform a number of actions, including discovery of information and execution of code.

---

## Attack Objective

Execute suspicious PowerShell commands commonly used in post-exploitation, including encoded command execution and invocation of credential access tooling, to validate PowerShell logging and process-based detection rules.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1059.001 -TestNumbers 1` |

### Test Description

Atomic test executes suspicious PowerShell patterns such as:
- `powershell -enc [Base64]`
- `IEX (New-Object Net.WebClient).DownloadString(...)`
- Mimikatz-related reflection/in-memory execution patterns

### Prerequisites

- [x] PowerShell Module Logging enabled (Event 4103)
- [x] Script Block Logging enabled (Event 4104)
- [x] Wazuh agent collecting PowerShell Operational log

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| PowerShell Operational | 4104 | Script Block Logging |
| PowerShell Operational | 4103 | Module Logging |
| Sysmon | 1 | Process Creation (powershell.exe) |
| Security | 4688 | Process creation (if audit enabled) |

### Key Indicators

- CommandLine contains `-enc`, `-EncodedCommand`, `IEX`, `DownloadString`
- Parent process: cmd.exe, wscript.exe, or Office application
- Script block contains `Invoke-Mimikatz` or similar

### Sample Log Excerpt

```
Event ID: 4104
ScriptBlockText: IEX (New-Object Net.WebClient).DownloadString('http://...')
Path: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100101 |
| **Level** | 12 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match PowerShell Event 4104 or Sysmon Event 1
- Regex on command line: `-enc|-EncodedCommand|IEX|DownloadString|Invoke-Mimikatz`
- Exclude known management tools if allowlisted

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_powershell_suspicious.yml` |
| **Product** | windows |
| **Service** | powershell |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ⚠️ | Generic PowerShell rules exist |
| Custom Wazuh | ✅ | Rule 100101 tuned for lab |
| Sigma Logic | ✅ | Covers encoded commands |

**Overall:** ✅ Full

---

## Detection Gaps

- PowerShell 7 (`pwsh.exe`) may not be collected by default
- Obfuscation (string concatenation, compression) evades simple regex
- Constrained Language Mode bypass techniques
- `-ExecutionPolicy Bypass` alone is insufficient indicator

---

## Remediation Recommendations

1. Enforce Script Block Logging and Transcription via GPO
2. Enable AMSI and monitor for AMSI bypass attempts
3. Deploy PowerShell Constrained Language Mode for standard users
4. Collect `pwsh.exe` logs if PowerShell 7 is installed
5. Use Microsoft Defender Attack Surface Reduction (ASR) rules for PowerShell

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1059-powershell.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1059-execution.png` |
| Event Log Screenshot | `screenshots/event-T1059-4104-scriptblock.png` |

---

## References

- [MITRE ATT&CK — T1059.001](https://attack.mitre.org/techniques/T1059/001/)
- [Atomic Red Team — T1059.001](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1059.001/T1059.001.md)
