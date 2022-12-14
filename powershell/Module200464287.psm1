function welcome {
  # Lab 2 COMP2101 welcome script for profile
  #
 
  write-output "Welcome to planet $env:computername Overlord $env:user"
  $now = get-date -format 'HH:mm tt on dddd'
  write-output "It is $now."
  Remove-Variable now
  echo `n
 }

function get-cpuinfo {
Get-CimInstance cim_processor | Format-List Manufacturer, Description, CurrentClockSpeed, MaxClockSpeed, NumberOfCores
 }

function get-mydisks {
get-disk | Format-Table FriendlyName, Model, SerialNumber, FirmwareVersion, Size
 }

# Lab 3 Function
function ipConfiguration {
# Lab 3 function
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $True } |
Format-Table -Property Description, Index, IpAddress, IPSubnet, DNSDomain, DNSServerSearchOrder -Autosize
}

# Lab 4 Functions
function osDesc {
    "####### System Hardware Description #######"
     Get-WmiObject win32_computersystem | Format-List Description
}

function osNameAndVersion {   
    "####### Operating System Name and Version #######"
    Get-WMIObject win32_operatingsystem | Format-List @{n ="OS Name";e={$_.Caption}}, Version
}

function processorInfo {    
   "####### Processor Information #######"
    $LOne = (Get-WMIObject win32_processor).L1CacheSize
    $LTwo = (Get-WMIObject win32_processor).L2CacheSize
    $LThree = (Get-WMIObject win32_processor).L3CacheSize

    if ($LOne -eq $null) {
        $LOne = "Data Empty or Does not exist"
    }
    
    if ($LTwo -eq $null) {
        $LTwo = "Data Empty or Does not exist"
    }

    if ($LThree -eq $null) {
        $LThree = "Data Empty or Does not exist"
    }

    Get-WMIObject win32_processor | Format-List @{n = "Speed (GHz)"; e= {$_.CurrentClockSpeed}}, NumberOfCores, 
    @{n = "L1 Cache Size (bytes)";e = {$LOne}},
    @{n = "L2 Cache Size (bytes)";e = {$LTwo}}, 
    @{n = "L3 Cache Size (bytes)";e= {$LThree}}
}

function ramSummary {    
    "####### RAM Information #######"
    $total = 0
    Get-WMIObject win32_physicalmemory | 
    foreach {
        new-object -TypeName psobject -Property @{Manufacturer = $_.manufacturer
        					  "Speed(MHz)" = $_.speed
        					  "Size(MB)" = $_.capacity/1mb
        					  Bank = $_.banklabel
						  Slot = $_.devicelocator
        					  }
    $total += $_.capacity/1mb
    } |
    Format-Table -AutoSize Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot
    "Total RAM: ${total}MB "
}

function diskDriveSummary {    
    "####### Disk Information #######" 
    $diskdrives = Get-CIMInstance CIM_diskdrive
    foreach ($disk in $diskdrives) {
       $partitions = $disk | Get-CimAssociatedInstance -ResultClassName CIM_diskpartition
       foreach ($partition in $partitions) {
             $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
             foreach ($logicaldisk in $logicaldisks) {
                      New-Object -TypeName psobject -Property @{Vendor=$disk.Manufacturer
								Model=$disk.Model
                                                                "Size(GB)"=$logicaldisk.size / 1gb -as [int]
								"Free Space(GB)"=$logicaldisk.freespace/1gb -as [int]
								"Percentage Free"=($logicaldisk.freespace)/($logicaldisk.size)*100 -as [float]
                                                                } | Format-Table -AutoSize Vendor, Model, "Size(GB)", "Free Space(GB)", "Percentage Free"
            }
      } 
  } 
}

function networkSummary {     
    "####### Network Information #######"
    ipconfiguration
} 

function videoSummary {    
    "####### Display Information #######"
    [string]$horizontal = $(Get-WMIObject win32_videocontroller).CurrentHorizontalResolution
    [string]$vertical = $(Get-WMIObject win32_videocontroller).CurrentVerticalResolution
    $resolution= $horizontal + ' x ' + $vertical
    Get-WMIObject win32_videocontroller | Fl @{n ="Vendor";e={$_.AdapterCompatibility}}, Description, @{n = 'Screen Resolution'; e = {$resolution}}
}