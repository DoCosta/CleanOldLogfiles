<# 
    ScriptVersion: 1.0
    ScriptOwner: Dominik Costa
    ScriptFunction: Delete Old Log-Files
#>

# Max Age in Days of Files, Default: 90 Days
$days=-0

# Change if Needed:  (ConfigFile)
$XmlFile = "C:\Users\%USERNAME%\Desktop\config.xml"
[XML]$empDetails = Get-Content $XmlFile


Clear-Host
Write-Host "`nRemoving logs older than" $days "days"`n

Foreach($data in $empDetails.config.path)
{
    $CurrentPath = $data.directory
    Write-Host "`nDelete Sub-Folders: " $CurrentPath
    $i = 0

    if($data.deleteSubDirectories -Like "true")
    {
        # CleanAllLogfiles deletes all Files including Subdirectories
        CleanAllLogfiles($CurrentPath)
        function CleanAllLogfiles()
        {
            param($FilePath)
    
            Foreach ($File in Get-ChildItem -Recurse -Path $FilePath)
            {
                Set-Location $FilePath
                if (!$File.PSIsContainerCopy) 
                {
                    # Delete All Files exept *.txt, *.log *.json
                    if (($File.LastWriteTime -le ($(Get-Date).Adddays(-$data.maxAgeOfFile))) -and (($File -Like "*.txt") -or ($File -Like "*.json") -or ($File -Like "*.log")))
                    {
                        Get-ChildItem -Path $FilePath -Include *.txt*, *.log*, *.json* -File -Recurse | foreach { $_.Delete()}
                        Write-Host "Removed logfile: "  $File
                        $i++
                    }
                }
            } Write-Host "In '$($CurrentPath)' wurden $i Files gelöscht`n"
        }
    }
    else
    {
        # CleanLogFiles only deletes Files on the same Path
        CleanLogfiles($CurrentPath)
        function CleanLogfiles()
        {
            param($FilePath)
            Set-Location $FilePath
            Foreach ($File in Get-ChildItem -Path $FilePath)
            {
                if (!$File.PSIsContainerCopy) 
                {
                    # Delete All Files exept *.txt, *.log *.json
                    if (($File.LastWriteTime -le ($(Get-Date).Adddays($days))) -and (($File -Like "*.txt") -or ($File -Like "*.json") -or ($File -Like "*.log")))
                    {
                        remove-item -path $File -force
                        Write-Host "Removed logfile: "  $File
                        $i++
                    }
                }
            } Write-Host "In '$($CurrentPath)' wurden $i Files gelöscht`n"
        }
    }
}
