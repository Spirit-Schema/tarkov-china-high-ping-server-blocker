$ErrorActionPreference = 'Stop'

$repositoryDirectory = Split-Path -Parent $PSCommandPath
$sourceDirectory = Join-Path $repositoryDirectory 'src'
$outputDirectory = Join-Path $repositoryDirectory 'dist'
$compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'

if (-not (Test-Path -LiteralPath $compiler)) {
    $compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\csc.exe'
}

if (-not (Test-Path -LiteralPath $compiler)) {
    throw 'The .NET Framework C# compiler was not found.'
}

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$commonArguments = @(
    '/nologo'
    '/target:winexe'
    '/optimize+'
    '/platform:anycpu'
    '/reference:System.dll'
    '/reference:System.Windows.Forms.dll'
    '/reference:Microsoft.CSharp.dll'
    ('/win32manifest:' + (Join-Path $sourceDirectory 'requireAdministrator.manifest'))
)

$blockArguments = $commonArguments + @(
    ('/out:' + (Join-Path $outputDirectory 'ExcludeChinaHighPingServer.exe'))
    (Join-Path $sourceDirectory 'FirewallRule.cs')
    (Join-Path $sourceDirectory 'BlockProgram.cs')
)
& $compiler @blockArguments
if ($LASTEXITCODE -ne 0) { throw 'Failed to build ExcludeChinaHighPingServer.exe.' }

$deleteArguments = $commonArguments + @(
    ('/out:' + (Join-Path $outputDirectory 'ExcludeChinaHighPingServer_Delete.exe'))
    (Join-Path $sourceDirectory 'FirewallRule.cs')
    (Join-Path $sourceDirectory 'DeleteProgram.cs')
)
& $compiler @deleteArguments
if ($LASTEXITCODE -ne 0) { throw 'Failed to build ExcludeChinaHighPingServer_Delete.exe.' }

$legacyDeleteFile = Join-Path $outputDirectory 'ExcludeChinaHighPingServerDelete.exe'
if (Test-Path -LiteralPath $legacyDeleteFile) {
    Remove-Item -LiteralPath $legacyDeleteFile -Force
}

$builtFiles = Get-Item -LiteralPath `
    (Join-Path $outputDirectory 'ExcludeChinaHighPingServer.exe'), `
    (Join-Path $outputDirectory 'ExcludeChinaHighPingServer_Delete.exe')

$checksumLines = foreach ($file in $builtFiles) {
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $file.FullName).Hash.ToLowerInvariant()
    "$hash  $($file.Name)"
}

Set-Content -LiteralPath (Join-Path $outputDirectory 'SHA256SUMS.txt') -Value $checksumLines -Encoding ASCII
$builtFiles | Select-Object Name, Length, LastWriteTime
