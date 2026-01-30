param ($Context, $DebugMode)

$Defaults = @(
    [System.Char]::ConvertFromUtf32(0xf0296),		# 󰊖
    [System.Char]::ConvertFromUtf32(0xf0954)		# 󰥔
)

$SteamID = $Context.Settings["Steam"]
$APIKey  = $Context.Secrets["STEAM_API_KEY"]

try {
    if (-not $SteamID -or -not $APIKey) { throw "Missing SteamID or API Key" }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Url = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$APIKey&steamid=$SteamID&format=json"
    $Data = Invoke-RestMethod -Uri $Url -TimeoutSec 15 -ErrorAction Stop
    
    $Games = $Data.response.games
    if (-not $Games) { throw "No games found (Check Privacy Settings!)" }

    $TotalGames = $Games.Count
    $TotalMins = ($Games | Measure-Object -Property playtime_forever -Sum).Sum
    $TotalHours = [math]::Round($TotalMins / 60, 0)

    return @{
        Text = "{0} $TotalGames  {1} ${TotalHours}h"
        Icons = $Defaults
    }
} catch {
    if ($DebugMode) { Write-Host "STEAM ERROR: $($_.Exception.Message)" -ForegroundColor Red }
    return $null
}