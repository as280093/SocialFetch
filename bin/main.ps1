param (
    [Parameter(Mandatory=$true)][string]$Module,
    [string]$Color = "Reset",
    [string]$Icons = "",
    [switch]$DebugMode
)

# 1. FORCE UTF8 FOR ICONS
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$LibDir = Join-Path $Root "lib"; $ConfigDir = Join-Path $Root "config"; $SrcDir = Join-Path $Root "src"

# 2. LOAD LIBRARIES
. "$LibDir\Colors.ps1"
. "$LibDir\Core.ps1"

$Context = Import-Configuration -ConfigDir $ConfigDir
$ModulePath = Join-Path $SrcDir "$Module.ps1"

if (-not (Test-Path $ModulePath)) { 
    Write-Host "CRITICAL: Module '$Module' not found at $ModulePath" -ForegroundColor Red
    exit 1 
}

# 3. EXECUTION LOGIC
$JsonResult = $null

if ($DebugMode) {
    Write-Host "--- DEBUG MODE ACTIVE ---" -ForegroundColor Cyan
    # Directly execute the script to see errors in real-time
    try {
        $Res = & $ModulePath -Context $Context -DebugMode $DebugMode
        if ($Res) { $JsonResult = $Res | ConvertTo-Json -Compress }
    } catch {
        Write-Host "MODULE CRASHED: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "STACK TRACE: $($_.ScriptStackTrace)" -ForegroundColor Gray
        exit 1
    }
} else {
    # Normal mode with Caching
    $CacheDuration = [int]$Context.Settings.Cache
    $JsonResult = Get-CachedResult -Name $Module -DurationMinutes $CacheDuration -Logic {
        try {
            $Res = & $ModulePath -Context $Context
            if ($Res) { return $Res | ConvertTo-Json -Compress }
            return $null
        } catch {
            return $null # Fallback to Offline in normal mode
        }
    }
}

# 4. OUTPUT RENDERING
if ($null -eq $JsonResult -or $JsonResult -eq "null") {
    Write-Output "Offline"
} else {
    try {
        $Data = $JsonResult | ConvertFrom-Json
        $UserIcons = if ($Icons) { $Icons -split "," } else { $null }
        $FinalIcons = if ($UserIcons) { $UserIcons } else { $Data.Icons }
        Set-Theme -Text $Data.Text -ColorName $Color -IconsToUse $FinalIcons
    } catch {
        # If result isn't JSON, show raw text
        Set-Theme -Text $JsonResult -ColorName $Color -IconsToUse @("?", "?", "?")
    }
}