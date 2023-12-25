# Author: Jinhwan Kim

# Define the DNS server IP address
$dnsServerIP = "127.0.0.1"  # Replace with your DNS server IP address

# List all DNS zones on the DNS server
$dnsZones = Get-DnsServerZone -ComputerName $dnsServerIP

# Choose a specific DNS zone to test
$selectedZone = "res.net"

# Get all DNS records from the specified zone
$dnsRecords = Get-DnsServerResourceRecord -ZoneName $selectedZone -ComputerName $dnsServerIP

# Loop through each DNS record and test the connectivity
foreach ($record in $dnsRecords) 
{
    $recordType = $record.RecordType
    $recordName = $record.HostName
    $recordData = $record.RecordData.IPV4Address

    # Skip non-A records
    if ($recordType -ne "A") 
    {
        Write-Host "Skipping non-A record: $recordName ($recordType)"
        continue
    }

    # Test the connectivity to the DNS record
    $result = Test-Connection -ComputerName $recordData -Count 1 -ErrorAction SilentlyContinue

    if ($result) 
    {
        Write-Host "DNS record $recordName ($recordType) at $recordData is reachable."
    } 
    else 
    {
        Write-Host "DNS record $recordName ($recordType) at $recordData is unreachable."
    }
}

Write-Host "DNS record testing completed."
