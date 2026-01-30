param ($Context, $DebugMode)

$Defaults = @(
    [char]0xf26c,                                    # 
    [System.Char]::ConvertFromUtf32(0xf051b),        # 󰔛 
    [char]0xf26c,                                    # 
    [System.Char]::ConvertFromUtf32(0xf051b),        # 󰔛
    [char]0xf008,                                    # 
    [System.Char]::ConvertFromUtf32(0xf051b)         # 󰔛
)

$InputUser = if ($Context.Settings["Simkl"]) { $Context.Settings["Simkl"].Trim() } else { $null }
$ClientID = $Context.Secrets["SIMKL_CLIENT_ID"]

if (-not $InputUser) { throw "User not configured" }

try {
    $Headers = if ($ClientID) { @{ "simkl-api-key" = $ClientID } } else { @{} }

    if ($InputUser -match "^\d+$") {
        $UserID = $InputUser
    }
    else {
        $SimklProfile = Invoke-RestMethod "https://api.simkl.com/users/$InputUser" -Headers $Headers -TimeoutSec 5
        $UserID = $SimklProfile.ids.simkl
    }

    $Url = "https://api.simkl.com/users/$UserID/stats"
    $Data = Invoke-RestMethod $Url -Headers $Headers -TimeoutSec 5 -ErrorAction Stop

    function Get-SafeCount ($Obj) {
        if (-not $Obj) { return 0 }
        if ($Obj.psobject.Properties["count"]) { return $Obj.psobject.Properties["count"].Value }
        if ($Obj.total_count) { return $Obj.total_count }
        if ($Obj.completed -and $Obj.completed.psobject.Properties["count"]) {
            return $Obj.completed.psobject.Properties["count"].Value
        }
        return 0
    }

    function Get-SafeHours ($Obj) {
        if (-not $Obj) { return "0h" }
        $Mins = if ($Obj.total_mins) { $Obj.total_mins } else { 0 }
        if ($Mins -gt 0) {
            return "$([math]::Floor($Mins / 60))h"
        }
        return "0h"
    }

    $AnimeCount = Get-SafeCount $Data.anime
    $AnimeTime = Get-SafeHours $Data.anime
    $TVCount = Get-SafeCount $Data.shows
    $TVTime = Get-SafeHours $Data.shows
    $MovCount = Get-SafeCount $Data.movies
    $MovTime = Get-SafeHours $Data.movies

    return @{
        Text  = "{0} $AnimeCount {1} $AnimeTime  {2} $TVCount {3} $TVTime  {4} $MovCount {5} $MovTime"
        Icons = $Defaults
    }

}
catch {
    if ($DebugMode) { throw $_ }
    return $null
}