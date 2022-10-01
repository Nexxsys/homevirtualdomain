# Home Virtual Home Lab Domain Setup
Virtual Domain for AD Pentesting

This will include the scripts for creating the users and groups on the domain.

### Enabling Remote-PSSession
This will replace the need for an SSH connection for our home lab learning and building.

In PowerShell on the Windows Server
```powershell
Enable-PSRemoting -Force
```

On the client we need to have the IP address of the Server (169.254.59.250) and run the following commands
```powershell
Start-Service WinRM

Set-Item WSMan:\localhost\Client\TrustedHosts -value 169.254.59.250
```

To create session
```powershell
New-PSSession -ComputerName 169.254.59.250 -Credential (Get-Credential)
```

The Get-Credential will prompt for the login credential information

```text
 Id Name            ComputerName    ComputerType    State         ConfigurationName     Availability
 -- ----            ------------    ------------    -----         -----------------     ------------
  1 WinRM1          169.254.59.250  RemoteMachine   Opened        Microsoft.PowerShell     Available

```

Now enter
```powershell
Enter-PSSession 1
```
