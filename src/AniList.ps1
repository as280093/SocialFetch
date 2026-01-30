param ($Context, $DebugMode)

$Defaults = @(
    [System.Char]::ConvertFromUtf32(0xf0448),		# 󰑈 
    [System.Char]::ConvertFromUtf32(0xf0208),		# 󰈈 
    [System.Char]::ConvertFromUtf32(0xf00ba),		# 󰂺 
    [System.Char]::ConvertFromUtf32(0xf0208) 		# 󰈈 
)

$User = $Context.Settings["AniList"]
$Token = $Context.Secrets["ANILIST_TOKEN"]

if (-not $User) { throw "User not configured" }

try {
    if ($Token) {
        $Query = "query { Viewer { statistics { anime { count episodesWatched } manga { count chaptersRead } } } }"
        $Headers = @{ "Authorization" = "Bearer $Token" }
    }
    else {
        $Query = "query { User(name: `"$User`") { statistics { anime { count episodesWatched } manga { count chaptersRead } } } }"
        $Headers = @{}
    }

    $Resp = Invoke-RestMethod "https://graphql.anilist.co" -Method Post `
        -Body (@{query = $Query } | ConvertTo-Json) -ContentType "application/json" `
        -Headers $Headers -TimeoutSec 5 -ErrorAction Stop

    if ($Resp.errors) { throw $Resp.errors[0].message }

    $Data = if ($Token) { $Resp.data.Viewer.statistics } else { $Resp.data.User.statistics }
    $A = $Data.anime
    $M = $Data.manga

    return @{
        Text  = "{0} $($A.count)  {1} $($A.episodesWatched)  {2} $($M.count)  {3} $($M.chaptersRead)"
        Icons = $Defaults
    }

}
catch {
    if ($DebugMode) { throw $_ }
    return $null
}