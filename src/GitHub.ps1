param ($Context, $DebugMode)

$Defaults = @(
    [char]0xf401,		# 
    [char]0xf407,		# 
    [char]0xf005,		# 
    [char]0xf007		# 
)
$User = $Context.Settings["GitHub"]
$Token = $Context.Secrets["GITHUB_TOKEN"]
if (-not $User) { throw "User not configured" }
try {
    $Headers = if ($Token) { @{ "Authorization" = "token $Token" } } else { @{} }
    $Url = if ($Token) { "https://api.github.com/user" } else { "https://api.github.com/users/$User" }
    $Me = Invoke-RestMethod $Url -Headers $Headers -TimeoutSec 5
    $TotalRepos = if ($Me.total_private_repos) { $Me.total_private_repos + $Me.public_repos } else { $Me.public_repos }
    return @{
        Text  = "{0} $TotalRepos  {1} $($Me.public_gists)  {2} $($Me.following)  {3} $($Me.followers)"
        Icons = $Defaults
    }
}
catch {
    if ($DebugMode) { throw $_ }
    return $null
}