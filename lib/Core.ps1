function Import-Configuration {
    param ($ConfigDir)
    
    $Config = @{ Settings = @{}; Secrets = @{} }
    
    $ConfFile = Join-Path $ConfigDir "settings.conf"
    if (Test-Path $ConfFile) {
        Get-Content $ConfFile | Where-Object { $_ -match '=' -and $_ -notmatch '^#' } | ForEach-Object {
            $k,$v = $_ -split '=', 2
            $Config.Settings[$k.Trim()] = $v.Trim()
        }
    }
    
    $EnvFile = Join-Path $ConfigDir ".env"
    if (Test-Path $EnvFile) {
        Get-Content $EnvFile | Where-Object { $_ -match '=' -and $_ -notmatch '^#' } | ForEach-Object {
            $k,$v = $_ -split '=', 2
            $Config.Secrets[$k.Trim()] = $v.Trim()
        }
    }
    return $Config
}

function Get-CachedResult {
    param ($Name, $DurationMinutes, [ScriptBlock]$Logic)

    if ($DurationMinutes -le 0) {
        try {
            return & $Logic
        } catch {
            return "Offline"
        }
    }

    $CacheFile = Join-Path (Split-Path -Parent $PSScriptRoot) "cache\$Name.txt"
    $CacheDir = Split-Path $CacheFile
    if (-not (Test-Path $CacheDir)) { New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null }
    if (Test-Path $CacheFile) {
        $LastWrite = (Get-Item $CacheFile).LastWriteTime
        $TimeDiff = (Get-Date) - $LastWrite
        
        if ($TimeDiff.TotalMinutes -lt $DurationMinutes) {
            return (Get-Content $CacheFile -Raw).Trim()
        }
    }

    try {
        $Result = & $Logic
        
        if ($Result -and $Result -ne "Offline") {
            $Result | Out-File -FilePath $CacheFile -Encoding utf8 -Force
        }
        return $Result
    } catch {
        if ($Global:DebugPreference -ne 'SilentlyContinue') { Write-Error $_ }
        
        if (Test-Path $CacheFile) { return (Get-Content $CacheFile -Raw).Trim() }
        return "Offline"
    }
}