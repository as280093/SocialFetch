param ($Context, $DebugMode)

$Defaults = @(
    [char]0xf26c,                                    # 
    [System.Char]::ConvertFromUtf32(0xf051b),        # 󰔛
    [System.Char]::ConvertFromUtf32(0xf00ba),        # 󰂺
    [char]0xf02d                                     # 
)

$User = $Context.Settings["Kitsu"]
if (-not $User) { throw "Kitsu user not configured" }

try {
    $UserUrl = "https://kitsu.io/api/edge/users?filter[name]=$User"
    $UserRes = Invoke-RestMethod -Uri $UserUrl -TimeoutSec 10 -ErrorAction Stop
    $UserID = $UserRes.data[0].id
    $MangaMetaUrl = "https://kitsu.io/api/edge/library-entries?filter[userId]=$UserID&filter[kind]=manga&page[limit]=1"
    $MangaMetaRes = Invoke-RestMethod -Uri $MangaMetaUrl -TimeoutSec 10 -ErrorAction Stop
    $RealManCount = $MangaMetaRes.meta.count
    $StatsUrl = "https://kitsu.io/api/edge/users/$UserID/stats"
    $StatsRes = Invoke-RestMethod -Uri $StatsUrl -TimeoutSec 10 -ErrorAction Stop
    function Get-KitsuData ($Kind, $Source) {
        $Obj = $Source | Where-Object { $_.attributes.kind -eq $Kind }
        if (-not $Obj) { return $null }
        $Data = $Obj.attributes.statsData
        if ($Data -is [string]) { return $Data | ConvertFrom-Json }
        return $Data
    }

    $AniStats = Get-KitsuData "anime-amount-consumed" $StatsRes.data
    $ManStats = Get-KitsuData "manga-amount-consumed" $StatsRes.data

    $AniCount = if ($AniStats.count -gt 0) { $AniStats.count } else { 0 }
    $AniSeconds = if ($AniStats.time) { $AniStats.time } else { 0 }
    $AniDays = [math]::Round($AniSeconds / 86400, 1)

    $ManChaps = if ($ManStats.units) { $ManStats.units } else { 0 }

    if ($DebugMode) { 
        Write-Host "[DEBUG] Found $RealManCount Manga entries and $ManChaps chapters." -ForegroundColor Green 
    }

    return @{
        Text  = "{0} $AniCount {1} ${AniDays}d  {2} $RealManCount {3} $ManChaps"
        Icons = $Defaults
    }
}
catch {
    if ($DebugMode) { Write-Host "[ERROR] Kitsu Sync Failed: $($_.Exception.Message)" -ForegroundColor Red }
    return $null
}