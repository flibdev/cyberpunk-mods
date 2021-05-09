$Target = "UI-Improvements.fomod"
$Paths = @(
    "fomod\",
    "images\",
    "r6\",
    "readme.txt"
)

Remove-Item $Target -ErrorAction Ignore

foreach ($file in $Paths) {
    & 7z a $Target -tzip $file    
}
