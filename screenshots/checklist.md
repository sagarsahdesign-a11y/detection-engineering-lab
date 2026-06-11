# Screenshots Checklist

Use this checklist to capture portfolio-ready evidence from your lab. Save all images to the `screenshots/` directory using the naming convention below.

---

## Naming Convention

```
screenshots/{category}-{technique}-{description}.png
```

**Examples:**
- `screenshots/alert-T1003-lsass-access.png`
- `screenshots/dashboard-alert-overview.png`
- `screenshots/atomic-T1110-execution.png`

---

## Required Screenshots (Portfolio Minimum)

| # | Category | Description | Filename | Status |
|---|----------|-------------|----------|--------|
| 1 | Dashboard | Wazuh Dashboard — Security Events overview (last 24h) | `dashboard-alert-overview.png` | ☑ |
| 2 | Dashboard | Wazuh Dashboard — Top 10 alerts by rule | `dashboard-top-alerts.png` | ☐ |
| 3 | Alert | T1003 LSASS access alert detail (rule 100103) | `alert-T1003-lsass-access.png` | ☑ |
| 4 | Alert | T1110 Brute force alert detail (rule 100100) | `alert-T1110-brute-force.png` | ☐ |
| 5 | Alert | T1136 Account creation alert (rule 100111) | `alert-T1136-account-creation.png` | ☐ |
| 6 | Atomic | PowerShell window running `Invoke-AtomicTest` | `atomic-invoke-atomictest.png` | ☐ |
| 7 | Atomic | T1059 PowerShell test output | `atomic-T1059-execution.png` | ☐ |
| 8 | ATT&CK | MITRE ATT&CK Navigator layer (colored) | `attack-navigator-layer.png` | ☑ |
| 9 | Rules | Custom Wazuh rule in Dashboard or XML editor | `rules-custom-wazuh-xml.png` | ☐ |
| 10 | Rules | Sigma rule in repository or Sigma CLI conversion | `rules-sigma-conversion.png` | ☐ |

---

## Per-Technique Screenshots (Full Documentation)

| Technique | Wazuh Alert | Atomic Execution | Windows Event Viewer | Status |
|-----------|-------------|------------------|----------------------|--------|
| T1110 Brute Force | `alert-T1110-brute-force.png` | `atomic-T1110-execution.png` | `event-T1110-4625-failures.png` | ☐ ☐ ☐ |
| T1059 PowerShell | `alert-T1059-powershell.png` | `atomic-T1059-execution.png` | `event-T1059-4104-scriptblock.png` | ☐ ☐ ☐ |
| T1547 Persistence | `alert-T1547-registry-run.png` | `atomic-T1547-execution.png` | `event-T1547-registry.png` | ☐ ☐ ☐ |
| T1003 Credential Dump | `alert-T1003-lsass-access.png` | `atomic-T1003-execution.png` | `event-T1003-sysmon10.png` | ☐ ☐ ☐ |
| T1021 Remote Services | `alert-T1021-rdp-logon.png` | `atomic-T1021-execution.png` | `event-T1021-4624-type10.png` | ☐ ☐ ☐ |
| T1078 Valid Accounts | `alert-T1078-logon.png` | `atomic-T1078-execution.png` | `event-T1078-4624-success.png` | ☐ ☐ ☐ |
| T1105 Ingress Transfer | `alert-T1105-download.png` | `atomic-T1105-execution.png` | `event-T1105-process-create.png` | ☐ ☐ ☐ |
| T1082 System Discovery | `alert-T1082-discovery-chain.png` | `atomic-T1082-execution.png` | `event-T1082-process-create.png` | ☐ ☐ ☐ |
| T1018 Remote Discovery | `alert-T1018-net-view.png` | `atomic-T1018-execution.png` | `event-T1018-process-create.png` | ☐ ☐ ☐ |
| T1047 WMI | `alert-T1047-wmi.png` | `atomic-T1047-execution.png` | `event-T1047-wmi-process.png` | ☐ ☐ ☐ |
| T1055 Process Injection | `alert-T1055-injection.png` | `atomic-T1055-execution.png` | `event-T1055-sysmon8.png` | ☐ ☐ ☐ |
| T1136 Create Account | `alert-T1136-account-creation.png` | `atomic-T1136-execution.png` | `event-T1136-4720.png` | ☐ ☐ ☐ |

---

## Architecture & Documentation Screenshots

| # | Description | Filename | Status |
|---|-------------|----------|--------|
| 1 | Lab VM topology (VirtualBox/VMware network diagram) | `lab-network-topology.png` | ☐ |
| 2 | Wazuh agent connected on victim machine | `lab-wazuh-agent-connected.png` | ☐ |
| 3 | Repository structure in IDE or GitHub | `repo-structure-github.png` | ☐ |
| 4 | Mermaid architecture rendered in GitHub README | `repo-architecture-diagram.png` | ☐ |

---

## Capture Tips

### Wazuh Dashboard
- Use dark or light theme consistently across all screenshots
- Crop to relevant panel (alert detail, rule description, timestamp)
- Ensure technique/rule ID is visible in the alert

### Event Viewer
- Highlight Event ID in the detail pane
- Include timestamp and computer name
- For Sysmon events, show Event Data XML with relevant fields

### Atomic Red Team
- Show full command: `Invoke-AtomicTest Txxxx -TestNumbers N`
- Include test name from ART output
- Redact any real hostnames if publishing publicly

### Image Quality
- Resolution: minimum 1280px width
- Format: PNG (preferred) or JPG
- No personal email/passwords in screenshots
- Blur or redact internal IP addresses if desired (192.168.x.x is fine for labs)

---

## README Integration

After capturing screenshots, reference them in the root README:

```markdown
## Lab Evidence

![Wazuh Alert Overview](screenshots/dashboard-alert-overview.png)
![T1003 LSASS Detection](screenshots/alert-T1003-lsass-access.png)
![ATT&CK Navigator Layer](screenshots/attack-navigator-layer.png)
```

---

## Pre-Publish Review

- [ ] No credentials or API keys visible
- [ ] Consistent naming convention applied
- [ ] Minimum 5 portfolio screenshots captured
- [ ] Screenshots referenced in README.md
- [ ] All images under 2MB (compress if needed)
