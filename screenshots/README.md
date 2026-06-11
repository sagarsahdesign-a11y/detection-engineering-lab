# Screenshots Directory

Place portfolio evidence images here. See [`checklist.md`](checklist.md) for required captures.

## Quick Capture Workflow

### From Wazuh Dashboard
1. Open **Threat Hunting** or **Security Events**
2. Filter by rule ID (e.g. `rule.id:100103`)
3. Click alert → expand **Rule** and **Full log**
4. Screenshot: Win+Shift+S (Windows) → save as PNG

### Naming
```
alert-T1003-lsass-access.png
atomic-T1110-execution.png
dashboard-alert-overview.png
```

### Minimum for README
Add these 3 to make the repo portfolio-ready:
- `dashboard-alert-overview.png`
- `alert-T1003-lsass-access.png`
- `attack-navigator-layer.png`

After adding images, they auto-render in the root `README.md` Lab Evidence section.
