function Build-ModArtifact {
    param (
        $TargetPath,
        $ListFile
    )

    $7z = Get-Command "7z.exe"

    Remove-Item $TargetPath -ErrorAction Ignore

    & $7z.Source a $TargetPath -tzip @$ListFile -bso0 -bsp0 -bse1

    if ($LastExitCode -gt 0) {
        Remove-Item $TargetPath -ErrorAction Ignore

        throw "7Zip didn't run flawlessly"
    }
    else {
        Write-Output "Built artifact: $TargetPath"
    }
}

Write-Output "`nBuilding Recommended"
Build-ModArtifact -TargetPath "build\UI-Improvements-Recommended.zip" -ListFile "build-recommended.txt"
