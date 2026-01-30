param ($Context, $DebugMode)

$Defaults = @([char]0xf44c, [char]0xf075)

$User = $Context.Settings["Reddit"]
if (-not $User) { throw "Reddit username not configured in settings.conf" }

try {
    if ($DebugMode) { Write-Host "[DEBUG] Fetching Reddit stats for: $User" -ForegroundColor Cyan }

    $Url = "https://www.reddit.com/user/$User/about.json"
    
    $Headers = @{
        "User-Agent" = "Windows:Socialfetch:v1.0 (by /u/$User)"
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Uri $Url -Headers $Headers -TimeoutSec 10 -ErrorAction Stop
    
    $Data = $Response.data
    if (-not $Data) { throw "User not found or API blocked." }

    $PostKarma = $Data.link_karma
    $CommKarma = $Data.comment_karma
    $TotalKarma = $Data.total_karma
    
    $CreatedYear = [DateTimeOffset]::FromUnixTimeSeconds($Data.created_utc).DateTime.ToString("yyyy")

    if ($DebugMode) { 
        Write-Host "[DEBUG] Success! Total Karma: $TotalKarma | Created: $CreatedYear" -ForegroundColor Green 
    }

    return @{
        Text  = "{0} $TotalKarma ($PostKarma/$CommKarma) {1} $CreatedYear"
        Icons = $Defaults
    }
}
catch {
    if ($DebugMode) { 
        Write-Host "[ERROR] Reddit Module Failed" -ForegroundColor Red
        Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    return $null
}