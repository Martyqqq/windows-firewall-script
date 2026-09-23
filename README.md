# windows-firewall-script
Dynamic PowerShell script for securing network communications

## How to Use
1. Launch PowerShell as Administrator.
2. Navigate to the script's location.
3. The script is unsigned and from the internet so you will need to momentarily bypass the execution policy. > ``Set-ExecutionPolicy Bypass -File fw-script.ps1``
5. This will run the file, but the function needs calling. > ``new-firewall``

## Features
- Asks user for the rule's display name
- Asks user for ports
- Asks user for the desired protocol
- Asks user for allowing or blocking this specific connection
- Asks user for a remote address, if applicable
- Asks user if they would like to create more rules for the current direction
- Asks user for inbound and outbound rules

## History
I first created this script file in April 2025 as I was preparing for NCCDC. \
This script ultimately was not used as we deemed it take up too much time and in NCCDC, you need all the time you can get in the early stages. \
We eventually went on to using a more static script that had everything, and we could manually create rules later if needed. \
This was still a fun challenge to get working. I would like to expand on this, eventually.
