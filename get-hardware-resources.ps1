while ($true) {
  #Gather the information on specific service
  $ServiceName = "vmmem"
  $ProcessMem = (Get-WmiObject Win32_Process -filter "Name = '$ServiceName'")
  $MemWorkingSet = $ProcessMem.WS
  $MemBySize = $MemWorkingSet/1GB
  $MemSize = [int]$MemBySize
  #Set the result text
  $serviceMem = "$ServiceName is using $MemSize GB of Memory"

  $storageFree = (get-ciminstance Win32_OperatingSystem | % FreePhysicalMemory) / 1000000
  $freeText = "There is $storageFree GB of Memory Remaining"

  $totalMemory = ((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb)

  $memList = (Get-WmiObject WIN32_PROCESS | Sort-Object -Property ws -Descending | Select-Object -first 5 Name,WS)
  $cpuLoad = (Get-WmiObject Win32_Processor | Select LoadPercentage)

  # Clear-Content .\index.html
  Clear-Content .\files\serviceMem.txt
  Clear-Content .\files\freeText.txt
  Clear-Content .\files\totalMemory.txt
  Clear-Content .\files\memList.txt
  Clear-Content .\files\cpuLoad.txt


  # Add-Content -Path .\index.html -Value ( "Memory <br />" )
  # Add-Content -Path .\index.html -Value ($serviceMem)
  Add-Content -Path .\files\serviceMem.txt -Value ($ServiceName)
  Add-Content -Path .\files\serviceMem.txt -Value ($MemSize)

  # Add-Content -Path .\index.html -Value ("<br />")
  # Add-Content -Path .\index.html -Value ($freeText)
  Add-Content -Path .\files\freeText.txt -Value ($storageFree)
  Add-Content -Path .\files\totalMemory.txt -Value ($totalMemory)

  # Add-Content -Path .\index.html -Value ("<br />")
  # Add-Content -Path .\index.html -Value ("Heavy Memory Services: <br />")
  # Add-Content -Path .\index.html -Value ($memList)
  Add-Content -Path .\files\memList.txt -Value ($memList)


  # Add-Content -Path .\index.html -Value ( "<br /><br /> CPU <br />" )
  # Add-Content -Path .\index.html -Value ($cpuLoad)
  Add-Content -Path .\files\cpuLoad.txt -Value ($cpuLoad)

  groovy format-site.groovy

  Write-Output "Sleeping for 5 seconds"
  Start-Sleep -Seconds 1
  Write-Output "."
  Start-Sleep -Seconds 1
  Write-Output ".."
  Start-Sleep -Seconds 1
  Write-Output "..."
  Start-Sleep -Seconds 1
  Write-Output "...."
  Start-Sleep -Seconds 1
  Write-Output "....."
  Clear-Host
  Write-Host "Refreshed!"
}
