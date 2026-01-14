# PowerShell

## Basics

### Cmdlet Pattern

Cmdlets follow the `<Verb>-<Noun>` pattern.

### Common Commands

**Get-Command**: List available cmdlets

```powershell
# Search for a command that has a noun starting with 'xyz'
Get-Command -Noun xyz*
```

**Get-Help**: Get help for commands

```powershell
Get-Help <command-name>
```

**Get-Member**: Get properties from command output

```powershell
<command> | Get-Member
```
