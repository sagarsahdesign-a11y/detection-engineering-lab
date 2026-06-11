# Wazuh Logtest Samples

Use these pre-built JSON log events on the **Wazuh Manager** to validate custom detection rules instantly without running active VM attack simulations.

## Usage

1. Launch `wazuh-logtest` on the Wazuh Manager:
   ```bash
   sudo /var/ossec/bin/wazuh-logtest
   ```
2. Copy the entire single-line JSON content from any sample file.
3. Paste it into the `wazuh-logtest` session and press Enter twice.
4. Verify that the output shows the expected **Rule ID** and **Mitre ATT&CK ID** firing.

---

## Logtest Samples Directory

| Sample File | Expected Rule ID | Technique | Event Source | Detection Objective |
|-------------|------------------|-----------|--------------|---------------------|
| `sysmon_lsass_access.txt` | **100103** | T1003.001 | Sysmon Event 10 | Direct handle access to LSASS memory (e.g., Mimikatz, Procdump) |
| `sysmon_comsvcs_dump.txt` | **1001031** | T1003.001 | Sysmon Event 1 | `rundll32.exe` abusing `comsvcs.dll` to dump LSASS memory |
| `sysmon_certutil_download.txt` | **100106** | T1105 | Sysmon Event 1 | `certutil.exe` download cradle (Ingress Tool Transfer) |
| `sysmon_net_view.txt` | **100108** | T1018 | Sysmon Event 1 | Remote domain system discovery via `net view` / `net group` |
| `security_account_created.txt` | **100111** | T1136.001 | Security Event 4720 | Local Windows user account creation |
| `security_brute_force.txt` | **100100** (Threshold) | T1110.003 | Security Event 4625 | Windows logon failure (requires 5 matches in 60s for alert) |
| `powershell_encoded.txt` | **100101** | T1059.001 | PowerShell Event 4104 | Suspicious script block containing encoding/decoding logic |
| `powershell_bypass_flags.txt` | **1001012** | T1059.001 | Sysmon Event 1 | PowerShell executed with ExecutionPolicy Bypass or Hidden style |
| `sysmon_registry_persistence.txt`| **100102** | T1547.001 | Sysmon Event 13 | Modification of Windows Startup `Run` registry key |
| `security_rdp_logon.txt` | **100104** | T1021.001 | Security Event 4624 | Successful interactive network RDP session (Logon Type 10) |
| `security_admin_offhours_logon.txt`| **100105** | T1078.003 | Security Event 4624 | Interactive local admin logon during off-business hours |
| `sysmon_system_info_discovery.txt`| **1001071** | T1082 | Sysmon Event 1 | System information gathering command (`whoami`, `systeminfo`) |
| `sysmon_wmi_execution.txt` | **1001091** | T1047 | Sysmon Event 1 | Command execution spawned via WMI Provider Service (`WmiPrvSE.exe`) |
| `sysmon_process_injection.txt` | **1001101** | T1055.001 | Sysmon Event 8 | Remote thread injection (`CreateRemoteThread`) into a system process |

---

## Exporting Your Own Test Logs

From your **Wazuh Dashboard**:
1. Click on an alert to expand the details.
2. Select the **JSON** tab.
3. Locate the raw log event under the `full_log` field, or extract the nested fields into a JSON structure matching the files above to test tuning modifications.
