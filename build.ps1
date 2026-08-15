# Copyright © 2026 Spirit-Schema. All rights reserved.
# Licensed under the Tarkov Server Guard Source-Available Freeware License 1.0.

param(
    [string]$PingCheckerArchive
)

$ErrorActionPreference = 'Stop'

$releaseVersion = '1.1.1'
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

$resolvedRepositoryDirectory = [IO.Path]::GetFullPath($repositoryDirectory).TrimEnd('\')
$resolvedOutputDirectory = [IO.Path]::GetFullPath($outputDirectory).TrimEnd('\')
$expectedOutputDirectory = Join-Path $resolvedRepositoryDirectory 'dist'
if (-not $resolvedOutputDirectory.Equals($expectedOutputDirectory, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Unexpected output directory: $resolvedOutputDirectory"
}
if (Test-Path -LiteralPath $resolvedOutputDirectory) {
    Remove-Item -LiteralPath $resolvedOutputDirectory -Recurse -Force
}
New-Item -ItemType Directory -Path $resolvedOutputDirectory | Out-Null

$commonArguments = @(
    '/nologo'
    '/target:winexe'
    '/optimize+'
    '/warn:4'
    '/platform:anycpu'
    '/reference:System.dll'
    '/reference:System.Windows.Forms.dll'
    '/reference:Microsoft.CSharp.dll'
    ('/win32manifest:' + (Join-Path $sourceDirectory 'requireAdministrator.manifest'))
    ('/resource:' + (Join-Path $repositoryDirectory 'LICENSE') + ',LICENSE.txt')
    ('/resource:' + (Join-Path $repositoryDirectory 'THIRD_PARTY_NOTICES.md') + ',THIRD_PARTY_NOTICES.md')
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

$blockExecutable = Join-Path $outputDirectory 'ExcludeChinaHighPingServer.exe'
$deleteExecutable = Join-Path $outputDirectory 'ExcludeChinaHighPingServer_Delete.exe'
$licenseOutput = Join-Path $outputDirectory 'LICENSE.txt'
$noticesOutput = Join-Path $outputDirectory 'THIRD_PARTY_NOTICES.md'
$readmeOutput = Join-Path $outputDirectory 'README.md'
$portableArchive = Join-Path $outputDirectory ("Tarkov-China-High-Ping-Server-Blocker-v{0}.zip" -f $releaseVersion)
$sourceArchive = Join-Path $outputDirectory ("Tarkov-China-High-Ping-Server-Blocker-Source-v{0}.zip" -f $releaseVersion)

Copy-Item -LiteralPath (Join-Path $repositoryDirectory 'LICENSE') -Destination $licenseOutput -Force
Copy-Item -LiteralPath (Join-Path $repositoryDirectory 'THIRD_PARTY_NOTICES.md') -Destination $noticesOutput -Force
Copy-Item -LiteralPath (Join-Path $repositoryDirectory 'README.md') -Destination $readmeOutput -Force

$portableStagingDirectory = Join-Path $outputDirectory '.portable-staging'
if (Test-Path -LiteralPath $portableStagingDirectory) {
    Remove-Item -LiteralPath $portableStagingDirectory -Recurse -Force
}
New-Item -ItemType Directory -Path $portableStagingDirectory | Out-Null
Copy-Item -LiteralPath $blockExecutable, $deleteExecutable, $licenseOutput, $noticesOutput, $readmeOutput `
    -Destination $portableStagingDirectory -Force
if (Test-Path -LiteralPath $portableArchive) {
    Remove-Item -LiteralPath $portableArchive -Force
}
Compress-Archive -Path (Join-Path $portableStagingDirectory '*') -DestinationPath $portableArchive -CompressionLevel Optimal
Remove-Item -LiteralPath $portableStagingDirectory -Recurse -Force

$sourceStagingDirectory = Join-Path $outputDirectory '.source-staging'
if (Test-Path -LiteralPath $sourceStagingDirectory) {
    Remove-Item -LiteralPath $sourceStagingDirectory -Recurse -Force
}
New-Item -ItemType Directory -Path $sourceStagingDirectory | Out-Null
Copy-Item -LiteralPath $sourceDirectory -Destination $sourceStagingDirectory -Recurse
Copy-Item -LiteralPath (Join-Path $repositoryDirectory '.github') -Destination $sourceStagingDirectory -Recurse
Copy-Item -LiteralPath (Join-Path $repositoryDirectory 'tools') -Destination $sourceStagingDirectory -Recurse
Copy-Item -LiteralPath `
    (Join-Path $repositoryDirectory '.gitignore'), `
    (Join-Path $repositoryDirectory 'build.ps1'), `
    (Join-Path $repositoryDirectory 'CONTRIBUTING.md'), `
    (Join-Path $repositoryDirectory 'README.md'), `
    (Join-Path $repositoryDirectory 'THIRD_PARTY_NOTICES.md') `
    -Destination $sourceStagingDirectory -Force
Copy-Item -LiteralPath (Join-Path $repositoryDirectory 'LICENSE') `
    -Destination (Join-Path $sourceStagingDirectory 'LICENSE.txt') -Force
if (Test-Path -LiteralPath $sourceArchive) {
    Remove-Item -LiteralPath $sourceArchive -Force
}
Compress-Archive -Path (Join-Path $sourceStagingDirectory '*') -DestinationPath $sourceArchive -CompressionLevel Optimal
Remove-Item -LiteralPath $sourceStagingDirectory -Recurse -Force

$builtFilePaths = @(
    $blockExecutable, `
    $deleteExecutable, `
    $portableArchive, `
    $sourceArchive, `
    $licenseOutput, `
    $noticesOutput, `
    $readmeOutput
)

if ($PingCheckerArchive) {
    $repackagedPingChecker = Join-Path $outputDirectory 'TarkovServerPingChecker-v0.3.0.zip'
    & (Join-Path $repositoryDirectory 'tools\RepackagePingChecker.ps1') `
        -InputArchive $PingCheckerArchive `
        -OutputArchive $repackagedPingChecker
    $builtFilePaths += $repackagedPingChecker
}

$builtFiles = Get-Item -LiteralPath $builtFilePaths

$checksumLines = foreach ($file in $builtFiles) {
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $file.FullName).Hash.ToLowerInvariant()
    "$hash  $($file.Name)"
}

Set-Content -LiteralPath (Join-Path $outputDirectory 'SHA256SUMS.txt') -Value $checksumLines -Encoding ASCII
$builtFiles | Select-Object Name, Length, LastWriteTime
