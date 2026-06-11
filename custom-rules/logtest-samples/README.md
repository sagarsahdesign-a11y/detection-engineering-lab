# Wazuh Logtest Samples

Use these samples on the **Wazuh Manager** to validate custom rules before or after Atomic Red Team runs.

## Usage

```bash
sudo /var/ossec/bin/wazuh-logtest
```

Paste a sample below, press Enter twice, and confirm the expected rule ID fires.

| Sample File | Expected Rule ID | Technique |
|-------------|------------------|-----------|
| `sysmon_lsass_access.txt` | 100103 | T1003.001 |
| `sysmon_certutil_download.txt` | 100106 | T1105 |
| `sysmon_net_view.txt` | 100108 | T1018 |
| `security_account_created.txt` | 100111 | T1136.001 |
| `powershell_encoded.txt` | 100101 | T1059.001 |

## Export Your Own Alerts

From Wazuh Dashboard → alert → **JSON** tab → copy `full_log` or raw event into a new `.txt` file here. Use that to tune `local_rules.xml` field names if a rule does not fire.
