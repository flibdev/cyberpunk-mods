$Target = "UI-Improvements-Recommended.zip"
$Paths = @(
    "r6\scripts\flib\_common\",
    "r6\scripts\flib\_shared\",
    "r6\scripts\flib\Crafting-MaxAmmo.reds",
    "r6\scripts\flib\DialerMenu-ByName.reds",
    "r6\scripts\flib\IconicItems-PreventRemoval.reds",
    "r6\scripts\flib\Messages-ByTimestamp.reds",
    "r6\scripts\flib\RipperDoc-OnlyCountUnowned.reds",
    "r6\scripts\flib\Scope-ShowType.reds",
    "r6\scripts\flib\Shards-ByName.reds"
)

Remove-Item $Target -ErrorAction Ignore

foreach ($file in $Paths) {
    & 7z a $Target $file    
}
