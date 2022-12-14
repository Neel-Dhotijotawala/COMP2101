# PowerShell Lab 4 Script
# This script collects system information and generates a report for the user

# This function collects the system hardware description using win32_computersystem
function osDesc {
    "####### System Hardware Description #######"
     Get-WmiObject win32_computersystem | Format-List Description
}

# This function collects the OS name and version numberusing win32_operatingsystem
function osNameAndVersion {   
    "####### Operating System Name and Version #######"
    Get-WMIObject win32_operatingsystem | Format-List @{n ="OS Name";e={$_.Caption}}, Version
}

# This function collects the processor description with speed, number of cores and sizes of the 3 caches if they are present using win32_processor
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

# This function collects the RAM summary using win32_physicalmemory and displays vendor, description, size, bank and slot for each DIMM information
# Reporting as a table and the total RAM installed as a summary line after the table
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

# This section includes the summary of physical disk drives (vendor, model, size, and percentage free) as a table
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

# This function includes the lab 3 network adapter configuration report script
function networkSummary {     
    "####### Network Information #######"
    .\\ipconfiguration.ps1
} 

# This function includes thevideo card vendor, description, and current screen resolution (horizontal x vertical) information using win32_videocontroller
function videoSummary {    
    "####### Display Information #######"
    [string]$horizontal = $(Get-WMIObject win32_videocontroller).CurrentHorizontalResolution
    [string]$vertical = $(Get-WMIObject win32_videocontroller).CurrentVerticalResolution
    $resolution= $horizontal + ' x ' + $vertical
    Get-WMIObject win32_videocontroller | Fl @{n ="Vendor";e={$_.AdapterCompatibility}}, Description, @{n = 'Screen Resolution'; e = {$resolution}}
}


####### Main Report (Calling all Functions) #######

"#########################################################################################"
osDesc

"#########################################################################################"
osNameAndVersion

"#########################################################################################"
processorInfo

"#########################################################################################"
ramSummary

"#########################################################################################"
diskDriveSummary

"#########################################################################################"
networkSummary

"#########################################################################################"
videoSummary

"#########################################################################################"