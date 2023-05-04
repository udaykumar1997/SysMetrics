# Retrieve system information
$TotalRAM = (Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory/1GB
$FreeRAM = (Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory/1GB
$UsedRAM = $TotalRAM - $FreeRAM
$CPUInfo = Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed
$GPUInfo = Get-CimInstance -ClassName Win32_VideoController | Select-Object Name, @{Name="AdapterRAM(GB)";Expression={$_.AdapterRAM/1GB}}

# Create the output table
$OutputTable = @{
    "System Information" = "Value"
    "------------------" = "-----"
    "Total RAM (GB)" = "$TotalRAM"
    "Available RAM (GB)" = "$FreeRAM"
    "Used RAM (GB)" = "$UsedRAM"
    "CPU Name" = $CPUInfo.Name
    "CPU Cores" = $CPUInfo.NumberOfCores
    "CPU Speed (GHz)" = $CPUInfo.MaxClockSpeed / 1000
    "GPU Name" = $GPUInfo.Name
    "GPU Memory (GB)" = $GPUInfo."AdapterRAM(GB)"
}

# Output the table in a visually appealing way
$OutputTable.GetEnumerator() | Format-Table -AutoSize | Out-String -Width 120 | Write-Host
