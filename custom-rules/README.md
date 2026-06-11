# Custom Wazuh Rules

Environment-tuned detection rules for the Detection Engineering Lab. Rule IDs **100100–100111** map to the 12 simulated MITRE ATT&CK techniques.

---

## Deployment

### 1. Copy rules to Wazuh Manager

```bash
sudo cp local_rules.xml /var/ossec/etc/rules/local_rules.xml
sudo chown root:wazuh /var/ossec/etc/rules/local_rules.xml
sudo chmod 640 /var/ossec/etc/rules/local_rules.xml
```

### 2. Verify XML syntax

```bash
sudo /var/ossec/bin/wazuh-logtest
```

### 3. Restart Wazuh Manager

```bash
sudo systemctl restart wazuh-manager
```

### 4. Confirm rules loaded

```bash
sudo grep "10010" /var/ossec/logs/ossec.log
```

Or check **Wazuh Dashboard → Management → Rules**.

---

## Rule Index

| Rule ID | ATT&CK | Level | Description |
|---------|--------|-------|-------------|
| 100100 | T1110.003 | 10 | Brute force threshold (5 fails / 60s) |
| 100101 | T1059.001 | 12 | Suspicious PowerShell script block |
| 1001011 | T1059.001 | 12 | Suspicious PowerShell command line |
| 100102 | T1547.001 | 10 | Registry Run key (Sysmon 13) |
| 1001021 | T1547.001 | 10 | reg.exe Run key modification |
| 100103 | T1003.001 | 14 | LSASS process access |
| 100104 | T1021.001 | 8 | RDP logon (Type 10) |
| 100105 | T1078.003 | 6 | Admin logon outside hours |
| 100106 | T1105 | 10 | certutil download |
| 1001061 | T1105 | 10 | bitsadmin transfer |
| 1001062 | T1105 | 10 | PowerShell download cradle |
| 100107 | T1082 | 6 | Discovery command chain (3 in 5 min) |
| 1001071 | T1082 | 3 | Single discovery command (building block) |
| 100108 | T1018 | 8 | net view / net group |
| 1001081 | T1018 | 8 | nltest DC enumeration |
| 100109 | T1047 | 10 | wmic process call create |
| 1001091 | T1047 | 10 | WmiPrvSE child process |
| 100110 | T1055.001 | 12 | CreateRemoteThread from script |
| 100111 | T1136.001 | 10 | Local account created |
| 1001111 | T1136.001 | 12 | User added to Administrators |

---

## Prerequisites

| Telemetry | Required For |
|-----------|--------------|
| Windows Security log | T1110, T1021, T1078, T1136 |
| Sysmon Event 1 (Process Create) | T1059, T1105, T1082, T1018, T1047 |
| Sysmon Event 8 (CreateRemoteThread) | T1055 |
| Sysmon Event 10 (Process Access) | T1003 |
| Sysmon Event 13 (Registry) | T1547 |
| PowerShell Operational (4104) | T1059 |

### Agent `ossec.conf` excerpt

```xml
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
<localfile>
  <location>Microsoft-Windows-PowerShell/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

---

## Testing Rules

### Logtest samples

Pre-built JSON samples are in [`logtest-samples/`](logtest-samples/). On the Wazuh Manager:

```bash
sudo /var/ossec/bin/wazuh-logtest < logtest-samples/sysmon_lsass_access.txt
```

Expected output includes `Rule: 100103`.

### Live validation

Trigger via Atomic Red Team:

```powershell
Invoke-AtomicTest T1003.001 -TestNumbers 1
```

Then verify alert in Dashboard with rule ID 100103.

---

## Tuning Notes

- **100105 (T1078):** Adjust `<time>` window for your timezone and business hours
- **100107 (T1082):** Increase `frequency` or `timeframe` if too noisy in active environments
- **100104 (T1021):** Add `<list>` exclusions for jump server IPs
- Parent rule SIDs (60122, 61603, etc.) assume Wazuh 4.x default ruleset

---

## Related

- [Sigma Rules](../sigma-rules/)
- [Attack Simulations](../docs/attack-simulations/)
- [Detection Gap Analysis](../reports/detection-gap-analysis.md)
