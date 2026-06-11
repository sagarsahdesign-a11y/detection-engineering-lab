# Portfolio Presentation Guide

How to present the Detection Engineering Lab in resumes, LinkedIn profiles, GitHub READMEs, and technical interviews.

---

## Elevator Pitch (30 seconds)

> "I built a detection engineering lab where I simulate 12 MITRE ATT&CK techniques using Atomic Red Team on a Windows endpoint, validate alerts in Wazuh, and document detection gaps. I authored custom Sigma and Wazuh rules, mapped coverage to ATT&CK, and produced a gap analysis with remediation recommendations—mirroring the workflow of a junior detection engineer."

---

## Resume Bullet Points

Choose 2–4 bullets tailored to the role:

**Detection Engineering / SOC Analyst:**
- Developed and validated 12 custom detection rules (Sigma + Wazuh) mapped to MITRE ATT&CK techniques in an isolated SIEM lab environment
- Executed Atomic Red Team attack simulations (T1003, T1059, T1110, T1055) and achieved 75% full detection coverage with documented gap analysis
- Analyzed Windows Security, Sysmon, and PowerShell logs to tune detection logic and reduce false positives

**Blue Team / Threat Detection:**
- Built end-to-end detection pipeline: attack simulation → log collection → rule authoring → alert validation → gap remediation
- Mapped detection coverage to MITRE ATT&CK Navigator layers across 8 tactics including Credential Access, Execution, and Persistence
- Documented telemetry requirements (Script Block Logging, Sysmon EID 8) to improve coverage for process injection and PowerShell abuse

---

## LinkedIn Project Section

**Title:** Detection Engineering Lab  
**URL:** `https://github.com/YOUR_USERNAME/detection-engineering-lab`

**Description:**
Hands-on detection engineering portfolio featuring Wazuh SIEM, Atomic Red Team, and MITRE ATT&CK. Includes 12 attack simulations, custom Sigma/Wazuh rules, ATT&CK mapping matrix, and detection gap analysis with remediation roadmap.

**Skills to tag:** MITRE ATT&CK, SIEM, Wazuh, Sigma, Threat Detection, Windows Security, PowerShell, Sysmon, Atomic Red Team, Log Analysis

---

## GitHub README Tips

Your README is already structured for recruiters and hiring managers. Before publishing:

1. Replace placeholder author section with your name and LinkedIn
2. Add 3–5 screenshots to `screenshots/` (see checklist)
3. Pin the repository on your GitHub profile
4. Add topics: `detection-engineering`, `wazuh`, `mitre-attack`, `sigma`, `atomic-red-team`, `blue-team`, `soc`

---

## Interview Talking Points

### "Walk me through a detection you built."

Use **T1003 Credential Dumping** as your example:
1. Selected technique from ATT&CK based on prevalence in ransomware/IR reports
2. Ran `Invoke-AtomicTest T1003.001 -TestNumbers 1` (mimikatz sekurlsa::logonpasswords or procdump LSASS)
3. Identified Sysmon Event 10 (Process Access) targeting `lsass.exe`
4. Wrote Sigma rule matching granted access 0x1010/0x1410
5. Converted to Wazuh custom rule ID 100103
6. Validated alert in dashboard; documented in attack simulation doc

### "What was your biggest detection gap?"

Discuss **T1055 Process Injection**:
- Detection depends on Sysmon Event ID 8 which is not in all default configs
- Partial coverage led to recommendation for SwiftOnSecurity Sysmon config
- Shows you understand telemetry limitations, not just rule writing

### "How do you reduce false positives?"

Reference **T1082 System Information Discovery**:
- Single `whoami` or `systeminfo` is too noisy
- Implemented command-chain correlation (3+ discovery commands in 5 minutes)
- Trade-off between coverage and alert fatigue

---

## Screenshots to Include

Minimum portfolio evidence (see [`screenshots/checklist.md`](../screenshots/checklist.md)):

| # | Screenshot | Purpose |
|---|------------|---------|
| 1 | Wazuh Dashboard alert overview | Shows live SIEM validation |
| 2 | Single high-severity alert (T1003 or T1110) | Demonstrates rule firing |
| 3 | ATT&CK Navigator layer | Visual coverage mapping |
| 4 | Atomic Red Team execution | Proves hands-on simulation |
| 5 | Custom rule in `local_rules.xml` | Shows rule authoring |

---

## What Interviewers Look For

| Skill | Evidence in This Repo |
|-------|----------------------|
| ATT&CK fluency | Mapping matrix, per-technique docs |
| Hands-on testing | Atomic Red Team test mapping |
| Rule writing | Sigma YAML + Wazuh XML |
| Critical thinking | Gap analysis with honest partial coverage |
| Documentation | Templates, architecture diagram |
| Professionalism | Disclaimer, structured repo, remediation roadmap |

---

## Optional Extensions

To strengthen the portfolio further:

1. **Sigma → Wazuh conversion** — Document `sigma convert` command output
2. **ATT&CK Navigator JSON layer** — Export and add to `assets/`
3. **Detection-as-Code** — Add GitHub Actions to validate Sigma syntax
4. **Video walkthrough** — 5-minute Loom demo of one simulation end-to-end
5. **Blog post** — Publish gap analysis findings on Medium or personal site

---

## Repository Maintenance

- Update technique docs when Atomic Red Team tests change GUIDs
- Re-validate rules after Wazuh major version upgrades
- Add new techniques quarterly to show continuous learning
- Tag releases: `v1.0-initial-lab`, `v1.1-tuning`

---

## Related Files

- [README](../README.md)
- [Detection Gap Analysis](../reports/detection-gap-analysis.md)
- [Screenshots Checklist](../screenshots/checklist.md)
