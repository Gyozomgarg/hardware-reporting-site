while ($true) {
  #Gather the information on specific service
  $ServiceName = "vmmem"
  $ProcessMem = (Get-WmiObject Win32_Process -filter "Name = '$ServiceName'")
  $MemWorkingSet = $ProcessMem.WS
  $MemBySize = $MemWorkingSet/1GB
  $MemSize = [int]$MemBySize
  #Set the result text
  $resultText = "$ServiceName is using $MemSize GB of Memory"

  $storageFree = (get-ciminstance Win32_OperatingSystem | % FreePhysicalMemory) / 1000000
  $freeText = "There is $storageFree GB of Memory Remaining"


  $memList = (Get-WmiObject WIN32_PROCESS | Sort-Object -Property ws -Descending | Select-Object -first 5 Name,WS)
  $cpuLoad = (Get-WmiObject Win32_Processor | Select LoadPercentage)

  Clear-Content .\index.html
  Add-Content -Path .\index.html -Value ( "Memory <br />" )
  Add-Content -Path .\index.html -Value ($resultText)
  Add-Content -Path .\index.html -Value ("<br />")
  Add-Content -Path .\index.html -Value ($freeText)
  Add-Content -Path .\index.html -Value ("<br />")
  Add-Content -Path .\index.html -Value ("Heavy Memory Services: <br />")
  Add-Content -Path .\index.html -Value ($memList)
  Add-Content -Path .\index.html -Value ( "<br /><br /> CPU <br />" )
  Add-Content -Path .\index.html -Value ($cpuLoad)
  Write-Output "Sleeping"
  Start-Sleep -Seconds 2
  Write-Output "========"
}