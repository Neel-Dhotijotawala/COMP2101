# PowerShell Lab 3 Script

# This script uses the Get-CimInstance and Where-Object command to create a report that shows the IP configuration and DNS information of all enabled adapters

Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $True } |
Format-Table -Property Description, Index, IpAddress, IPSubnet, DNSDomain, DNSServerSearchOrder -Autosize

# End of Script