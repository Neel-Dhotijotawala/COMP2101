# PowerShell Lab 5 Script
# This Modified script collects system information and generates a report for the user according to the command line arguments

param([switch]$System,
      [switch]$Disks,
      [switch]$Network
)

if ($System) { 
	processorInfo
	osNameAndVersion
	ramSummary
	videoSummary
}
elseif ($Disks) {
	diskDriveSummary
}
elseif ($Network) {
	networkSummary
}
else {
	osDesc
	osNameAndVersion
	processorInfo
	ramSummary
	diskDriveSummary
	networkSummary
	videoSummary
}