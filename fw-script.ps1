# Firewall Profile settings
Set-NetFirewallProfile -Profile Domain, Private, Public -Enabled True
Set-NetFirewallProfile -Profile Domain, Private, Public -DefaultInboundAction Block -DefaultOutboundAction Block
Set-NetFirewallProfile -LogAllowed True -LogBlocked True -LogIgnored True -LogMaxSizeKilobytes 32767
Set-NetFirewallProfile -NotifyOnListen True

# Disable and Remove current rules for cleaner review
Get-NetFirewallRule | Disable-NetFirewallRule
Get-NetFirewallRule | Remove-NetFirewallRule


# Function containing everything
function new-firewall {
    param(
        [ValidateSet("Inbound", "Outbound")]
        [string]$Direction
    )
    
    # Inbound/Outbound rules will need to take turns
    while ($true) {
        Write-Host "`n--- $Direction Firewall Rules ---`n" -ForegroundColor Cyan

        # User prompts
        $ports = Read-Host "Enter $Direction port(s) (comma-separated - 80,443,8080)"
        $protocol = Read-Host "Enter protocol (TCP/UDP)"
        $action = Read-Host "Allow or Block connection? (Allow/Block)"
        $ruleName = Read-Host "Enter a name for this rule"
        $remoteAddress = Read-Host "Enter Remote Address (leave blank to allow all)"

        $portList = ($ports -split ',' | ForEach-Object { $_.Trim() })

        # Firewall rule parameters
        foreach ($port in $portList) {
            $params = @{
                DisplayName = "$ruleName - Port $port"
                Direction   = $Direction.ToLower()
                Protocol    = $protocol.ToUpper()
                Action      = $action
                Profile     = 'Any'
            }

            if ($Direction -eq "Inbound") {
                $params["LocalPort"] = $port
            } else {
                $params["RemotePort"] = $port
            }

            if ($remoteAddress -ne '') {
                $params["RemoteAddress"] = $remoteAddress
            }

            # Rule creation and user feedback
            try {
                New-NetFirewallRule @params
                Write-Host "$! Created $Direction rule for port $port ($protocol - $action) !$" -ForegroundColor Green
                if ($remoteAddress) {
                    Write-Host "{~ RemoteAddress applied: $remoteAddress ~}`n" -ForegroundColor Gray
                }
            } catch {
                Write-Error " Failed to create rule for port ${port}: $_"
            }
        }

        # Rule creation loop
        $again = Read-Host "`nWould you like to create another $Direction rule? (Y/N)"
        if ($again.ToUpper() -ne 'Y') { break }
    }
}


# Call function for Inbound rules
new-firewall -Direction "Inbound"

# Call function for Outbound rules
new-firewall -Direction "Outbound"