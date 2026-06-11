# T1547 — Boot or Logon Autostart Execution

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1547.001 |
| **Tactic** | Persistence |
| **Simulation Date** | 2025-06-03 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may achieve persistence by adding a program to a startup folder or referencing it with a Registry run key. Adding an entry to the Run keys in the Registry or startup folder will cause the program referenced to be executed when a user logs in. Programs listed in the Run keys run at logon.

---

## Attack Objective

Establish persistence by adding a malicious entry to the `HKCU\Software\Microsoft\Windows\CurrentVersion\Run` registry key, simulating malware that survives reboots and user logons.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1547.001 -TestNumbers 1` |

### Test Command (typical)

```cmd
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v AtomicRedTeam /t REG_SZ /d "C:\Windows\System32\cmd.exe" /f
```

### Prerequisites

- [x] Registry auditing or Sysmon Event 13 (RegistryEvent) enabled
- [x] Wazuh agent collecting relevant logs

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Sysmon | 13 | Registry value set |
| Security | 4657 | Registry value modified (if SACL configured) |
| Sysmon | 1 | reg.exe process creation |

### Key Fields

- `TargetObject`: `*\CurrentVersion\Run`
- `Details`: path to executable
- `Image`: reg.exe or powershell.exe

### Sample Log Excerpt

```
Event ID: 13 (Sysmon)
EventType: CreateKey
TargetObject: HKCU\Software\Microsoft\Windows\CurrentVersion\Run\AtomicRedTeam
Details: C:\Windows\System32\cmd.exe
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100102 |
| **Level** | 10 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match registry modifications to `CurrentVersion\Run` or `RunOnce` keys
- Match via Sysmon Event 13 or reg.exe command line containing `CurrentVersion\Run`

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_registry_run_key_persistence.yml` |
| **Product** | windows |
| **Service** | sysmon |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ⚠️ | Limited registry-specific rules |
| Custom Wazuh | ✅ | Rule 100102 |
| Sigma Logic | ✅ | Sysmon registry events |

**Overall:** ✅ Full

---

## Detection Gaps

- Legitimate software installers frequently write Run keys (high FP potential)
- WMI-based persistence (subscription) not covered by this test
- Startup folder (`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`) alternative path

---

## Remediation Recommendations

1. Baseline autoruns with Sysinternals Autoruns tool
2. Alert on new Run key entries not matching software inventory
3. Enable Sysmon Event 13 with targeted registry paths
4. Restrict registry write permissions for standard users where possible

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1547-registry-run.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1547-execution.png` |
| Event Log Screenshot | `screenshots/event-T1547-registry.png` |

---

## References

- [MITRE ATT&CK — T1547.001](https://attack.mitre.org/techniques/T1547/001/)
- [Atomic Red Team — T1547.001](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1547.001/T1547.001.md)
