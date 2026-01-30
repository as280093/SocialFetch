$ESC = [char]27

$ThemeColors = @{
    "reset"         = "$ESC[0m"
    
    # Standard (Foreground)
    "black"         = "$ESC[30m"
    "red"           = "$ESC[31m"
    "green"         = "$ESC[32m"
    "yellow"        = "$ESC[33m"
    "blue"          = "$ESC[34m"
    "magenta"       = "$ESC[35m"
    "cyan"          = "$ESC[36m"
    "white"         = "$ESC[37m"
    
    # Bright / Bold (Foreground)
    "brightblack"   = "$ESC[90m"
    "gray"          = "$ESC[90m"
    "brightred"     = "$ESC[91m"
    "brightgreen"   = "$ESC[92m"
    "brightyellow"  = "$ESC[93m"
    "brightblue"    = "$ESC[94m"
    "brightmagenta" = "$ESC[95m"
    "brightcyan"    = "$ESC[96m"
    "brightwhite"   = "$ESC[97m"
}

function Set-Theme {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text,
        
        [Parameter(Mandatory=$true)]
        [string]$ColorName,
        
        [Parameter(Mandatory=$false)]
        [array]$IconsToUse
    )

    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    $C = if ($ThemeColors[$ColorName.ToLower()]) { $ThemeColors[$ColorName.ToLower()] } else { $ThemeColors["reset"] }
    $R = $ThemeColors["reset"]

    $FinalIcons = if ($IconsToUse -and $IconsToUse.Count -gt 0) { $IconsToUse } else { @("?", "?", "?", "?") }

    for ($i=0; $i -lt $FinalIcons.Count; $i++) {
        $Placeholder = "{$i}"
        if ($Text.Contains($Placeholder)) {
            $IconBlock = "$C$($FinalIcons[$i])$R"
            $Text = $Text.Replace($Placeholder, $IconBlock)
        }
    }

    Write-Output $Text
}