# Minimal Integration Tests for PSDify

```powershell
# Run all tests in all environments on all powershell versions
.\Tests\Invoke-PSDifyPester.ps1

# Specify environment
.\Tests\Invoke-PSDifyPester.ps1 -Env "cloud-prod", "community-release"

# Specify powershell version
.\Tests\Invoke-PSDifyPester.ps1 -Ps 7

# Specify tests
.\Tests\Invoke-PSDifyPester.ps1 -Tag "init", "auth", "member", "plugin", "model", "systemmodel", "knowledge", "document", "app", "chat"
```
