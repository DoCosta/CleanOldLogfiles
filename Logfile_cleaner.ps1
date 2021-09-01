<# 
    ScriptVersion: 1.0
    ScriptOwner: Dominik Costa
    ScriptFunction: Delete Old Log-Files
    
#>

# Max Age in Days of Files, Default: 90 Days
$days=-0

# Change if Needed:  (ConfigFile)
$ConfigFile = "C:\Users\Costd0\Desktop\array.txt"

Clear-Host

Write-Host "`nRemoving logs older than" $days "days"`n

$a = [string[]](Get-Content $ConfigFile)

Foreach($data in $a)
{
    $CurrentLine = $data.Split((";"))
    Write-Host "`nDelete Sub-Folders: " $CurrentLine[1]
    $i = 0

    if($CurrentLine[1] -Like "true")
    {
        # CleanAllLogfiles deletes all Files including Subdirectories
        CleanAllLogfiles($CurrentLine[0])
        function CleanAllLogfiles()
        {
            param($FilePath)
    
            Foreach ($File in Get-ChildItem -Recurse -Path $FilePath)
            {
                Set-Location $FilePath
                if (!$File.PSIsContainerCopy) 
                {
                    # Delete All Files exept *.txt, *.log *.json
                    if (($File.LastWriteTime -le ($(Get-Date).Adddays($days))) -and (($File -Like "*.txt") -or ($File -Like "*.json") -or ($File -Like "*.log")))
                    {
                        Get-ChildItem -Path $FilePath -Include *.txt*, *.log*, *.json* -File -Recurse | foreach { $_.Delete()}
                        Write-Host "Removed logfile: "  $File
                        $i++
                    }
                }
            } Write-Host "In '$($CurrentLine[0])' wurden $i Files gelöscht`n"
        }
    }
    else
    {
        # CleanLogFiles only deletes Files on the same Path
        CleanLogfiles($CurrentLine[0])
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
            } Write-Host "In '$($CurrentLine[0])' wurden $i Files gelöscht`n"
        }
    }
}
