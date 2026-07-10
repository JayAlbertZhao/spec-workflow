[CmdletBinding()]
param(
    [string]$CodexExe,
    [string]$OutputPath = (Join-Path $env:USERPROFILE ".codex\prompts\gpt-5.6-sol-base-without-commentary.md"),
    [string]$Model = "gpt-5.6-sol"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $CodexExe) {
    $managedBin = Join-Path $env:LOCALAPPDATA "OpenAI\Codex\bin"
    $candidate = Get-ChildItem -Path $managedBin -Filter codex.exe -File -Recurse -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($candidate) {
        $CodexExe = $candidate.FullName
    } else {
        $CodexExe = (Get-Command codex -ErrorAction Stop).Source
    }
}

$catalog = (& $CodexExe debug models --bundled) | ConvertFrom-Json
$entry = $catalog.models | Where-Object slug -eq $Model
if (-not $entry) {
    throw "Model '$Model' is absent from the bundled catalog exposed by '$CodexExe'."
}

$base = [string]$entry.base_instructions
$startMarker = "## Intermediate commentary"
$endMarker = "## Final answer"
$start = $base.IndexOf($startMarker, [StringComparison]::Ordinal)
$end = $base.IndexOf($endMarker, [StringComparison]::Ordinal)

if ($start -lt 0 -or $end -le $start) {
    throw "Expected commentary section boundaries were not found; refusing to generate a partial prompt."
}

$custom = $base.Remove($start, $end - $start)
if (-not $custom.EndsWith("`n", [StringComparison]::Ordinal)) {
    $custom += "`n"
}
$parent = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $parent | Out-Null
[IO.File]::WriteAllText($OutputPath, $custom, [Text.UTF8Encoding]::new($false))

function Get-TextSha256([string]$Text) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        return (($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text)) |
            ForEach-Object { $_.ToString("x2") }) -join "")
    } finally {
        $sha.Dispose()
    }
}

[pscustomobject]@{
    model = $entry.slug
    codex_exe = $CodexExe
    output_path = (Resolve-Path $OutputPath).Path
    source_sha256 = Get-TextSha256 $base
    generated_sha256 = Get-TextSha256 $custom
    removed_section = $startMarker
    source_characters = $base.Length
    generated_characters = $custom.Length
} | ConvertTo-Json
