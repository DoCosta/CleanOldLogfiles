function CleanAllLogfiles()
{
    param($FilePath)

    Foreach ($File in Get-ChildItem -Recurse -Path $FilePath)
    {
        if (!$File.PSIsContainerCopy) 
        {
            # Delete All Files with extension *.txt, *.log *.json
            # Write-Host $File.LastWriteTime
            if (($File.LastWriteTime -le ($(Get-Date).Adddays(-$data.maxAgeOfFile))) -and (($File -Like "*.txt") -or ($File -Like "*.json") -or ($File -Like "*.log")))
            {
                Get-ChildItem -Path $FilePath -Include *.txt*, *.log*, *.json* -File -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-$data.maxAgeOfFile)} | foreach { $_.Delete()}
                Write-Host "Removed logfile: "  $File
                $i++
            }
        }
    } Write-Host "In '$($CurrentPath)' wurden $i Files gelöscht`n"
    
    Set-Location $standardPath
}

function CleanLogfiles()
{
    param($FilePath)
    Set-Location $FilePath
    Foreach ($File in Get-ChildItem -Path $FilePath)
    {
        if (!$File.PSIsContainerCopy) 
        {
            # Delete All Files with extension *.txt, *.log *.json
            if (($File.LastWriteTime -le ($(Get-Date).Adddays(-$data.maxAgeOfFile))) -and (($File -Like "*.txt") -or ($File -Like "*.json") -or ($File -Like "*.log")))
            {
                remove-item -path $File -force
                Write-Host "Removed logfile: "  $File
                $i++
            }
        }
    } Write-Host "In '$($CurrentPath)' wurden $i Files gelöscht`n"
    
    Set-Location $standardPath
}


# Change if Needed:  (ConfigFile)
$XmlFile = ".\config.xml"
[XML]$empDetails = Get-Content $XmlFile
$standardPath = Get-Location

Clear-Host

Foreach($data in $empDetails.config.path)
{
    $CurrentPath = $data.directory
    Write-Host "`nDelete Sub-Folders: " $CurrentPath
    $i = 0
    
    if($data.deleteSubDirectories -Like "true")
    {
        # CleanAllLogfiles deletes all Files including Subdirectories
        CleanAllLogfiles($CurrentPath)
    }
    else
    {
        # CleanLogFiles only deletes Files on the same Path
        CleanLogfiles($CurrentPath)
    }
}
