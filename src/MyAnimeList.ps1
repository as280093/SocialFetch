param ($Context, $DebugMode)

$Defaults = @(
    [System.Char]::ConvertFromUtf32(0xf0448),		# 󰑈 
    [System.Char]::ConvertFromUtf32(0xf0208),		# 󰈈 
    [System.Char]::ConvertFromUtf32(0xf00ba),		# 󰂺 
    [System.Char]::ConvertFromUtf32(0xf0208)		# 󰈈 
)

$User = $Context.Settings["MyAnimeList"]

try {
    if ($DebugMode) { Write-Host "[DEBUG] Target: $User" -ForegroundColor Cyan }
    if (-not $User) { throw "Username missing in settings.conf" }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Headers = @{ "User-Agent" = "Mozilla/5.0" }

    $Url = "https://api.jikan.moe/v4/users/$User/statistics"
    if ($DebugMode) { Write-Host "[DEBUG] Fetching: $Url" -ForegroundColor Cyan }

    $Response = Invoke-RestMethod -Uri $Url -Headers $Headers -TimeoutSec 15 -ErrorAction Stop
    $Stats = $Response.data
        
    if (-not $Stats) { throw "API returned success but 'data' field was missing." }

    $Ani = $Stats.anime.total_entries
    $Eps = $Stats.anime.episodes_watched
    $Man = $Stats.manga.total_entries
    $Cha = $Stats.manga.chapters_read

    return @{
        Text  = "{0} $Ani  {1} $Eps  {2} $Man  {3} $Cha"
        Icons = $Defaults
    }
}
catch {
    if ($DebugMode) { 
        Write-Host "[ERROR] MyAnimeList Failed" -ForegroundColor Red
        Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    return $null
}