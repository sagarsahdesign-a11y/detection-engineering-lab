# Attack Simulations Index

Documentation for all 12 MITRE ATT&CK techniques simulated in the Detection Engineering Lab.

---

## Simulations

| # | ID | Technique | Status | Document |
|---|-----|-----------|--------|----------|
| 1 | T1110.003 | Brute Force (Password Spraying) | ✅ | [T1110-brute-force.md](T1110-brute-force.md) |
| 2 | T1059.001 | PowerShell | ✅ | [T1059-powershell.md](T1059-powershell.md) |
| 3 | T1547.001 | Registry Run Keys (Persistence) | ✅ | [T1547-persistence.md](T1547-persistence.md) |
| 4 | T1003.001 | LSASS Credential Dumping | ✅ | [T1003-credential-dumping.md](T1003-credential-dumping.md) |
| 5 | T1021.001 | Remote Desktop Protocol | ✅ | [T1021-remote-services.md](T1021-remote-services.md) |
| 6 | T1078.003 | Valid Accounts (Local) | ⚠️ | [T1078-valid-accounts.md](T1078-valid-accounts.md) |
| 7 | T1105 | Ingress Tool Transfer | ✅ | [T1105-ingress-tool-transfer.md](T1105-ingress-tool-transfer.md) |
| 8 | T1082 | System Information Discovery | ⚠️ | [T1082-system-information-discovery.md](T1082-system-information-discovery.md) |
| 9 | T1018 | Remote System Discovery | ✅ | [T1018-remote-system-discovery.md](T1018-remote-system-discovery.md) |
| 10 | T1047 | Windows Management Instrumentation | ✅ | [T1047-wmi.md](T1047-wmi.md) |
| 11 | T1055.001 | DLL Process Injection | ⚠️ | [T1055-process-injection.md](T1055-process-injection.md) |
| 12 | T1136.001 | Create Local Account | ✅ | [T1136-create-account.md](T1136-create-account.md) |

---

## Document Structure

Each simulation document includes:

- ATT&CK description and attack objective
- Atomic Red Team test reference and execution steps
- Expected Windows logs with sample excerpts
- Wazuh detection logic (rule ID and match conditions)
- Sigma rule file reference
- Detection coverage assessment
- Detection gaps and remediation recommendations
- Screenshot evidence locations

---

## Template

To add new simulations, copy [`../templates/attack-simulation-template.md`](../templates/attack-simulation-template.md).

---

## Related

- [MITRE ATT&CK Mapping](../mitre-attack-mapping.md)
- [Atomic Red Team Test Mapping](../../atomic-red-team-tests/test-mapping.md)
- [Detection Gap Analysis](../../reports/detection-gap-analysis.md)
