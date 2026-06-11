# Sigma Rules

Vendor-agnostic detection rules for the Detection Engineering Lab. Each rule maps to one MITRE ATT&CK technique simulated in the lab.

---

## Rules Index

| File | ATT&CK | Level | Description |
|------|--------|-------|-------------|
| `win_security_brute_force.yml` | T1110.003 | high | Multiple failed logons (brute force) |
| `win_powershell_suspicious.yml` | T1059.001 | high | Encoded/suspicious PowerShell |
| `win_registry_run_key_persistence.yml` | T1547.001 | medium | Registry Run key modification |
| `win_lsass_access.yml` | T1003.001 | critical | LSASS process access |
| `win_rdp_logon.yml` | T1021.001 | medium | RDP logon (Type 10) |
| `win_valid_account_logon.yml` | T1078.003 | low | Suspicious admin interactive logon |
| `win_ingress_tool_transfer.yml` | T1105 | high | LOLBin file download |
| `win_system_info_discovery.yml` | T1082 | low | System info discovery commands |
| `win_remote_system_discovery.yml` | T1018 | medium | net view / nltest enumeration |
| `win_wmi_execution.yml` | T1047 | high | WMI process execution |
| `win_process_injection.yml` | T1055.001 | high | CreateRemoteThread (injection) |
| `win_account_creation.yml` | T1136.001 | medium | Local account created |

---

## Convert to Wazuh

Install [Sigma CLI](https://github.com/SigmaHQ/sigma-cli) and convert:

```bash
pip install sigma-cli
sigma plugin install wazuh
sigma convert -t wazuh sigma-rules/win_lsass_access.yml
```

Compare output with `custom-rules/local_rules.xml` for field mapping validation.

---

## Validate Syntax

```bash
pip install pysigma
sigma check sigma-rules/
```

---

## Related

- [Custom Wazuh Rules](../custom-rules/local_rules.xml)
- [Attack Simulations](../docs/attack-simulations/)
- [MITRE Mapping](../docs/mitre-attack-mapping.md)
