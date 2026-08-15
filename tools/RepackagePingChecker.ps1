# Copyright © 2026 Spirit-Schema. All rights reserved.
# Licensed under the Tarkov Server Guard Source-Available Freeware License 1.0.

param(
    [Parameter(Mandatory = $true)]
    [string]$InputArchive,

    [Parameter(Mandatory = $true)]
    [string]$OutputArchive
)

$ErrorActionPreference = 'Stop'

$expectedInputSha256 = 'd099cb027b22d0cc6207034b42bd8b5a53443ddbfd44f6db21b03ef708fb3530'
$repositoryDirectory = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$resolvedInputArchive = (Resolve-Path -LiteralPath $InputArchive).Path
$actualInputSha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $resolvedInputArchive).Hash.ToLowerInvariant()

if ($actualInputSha256 -ne $expectedInputSha256) {
    throw "Unexpected TarkovServerPingChecker-v0.3.0.zip SHA-256: $actualInputSha256"
}

$outputParent = Split-Path -Parent $OutputArchive
if (-not (Test-Path -LiteralPath $outputParent)) {
    New-Item -ItemType Directory -Path $outputParent | Out-Null
}
$resolvedOutputParent = (Resolve-Path -LiteralPath $outputParent).Path
$stagingDirectory = Join-Path $resolvedOutputParent '.ping-checker-staging'

if (Test-Path -LiteralPath $stagingDirectory) {
    Remove-Item -LiteralPath $stagingDirectory -Recurse -Force
}

try {
    Expand-Archive -LiteralPath $resolvedInputArchive -DestinationPath $stagingDirectory -Force

    $legacyProjectLicense = Join-Path $stagingDirectory 'LICENSE'
    $thirdPartyNotices = Join-Path $stagingDirectory 'THIRD_PARTY_NOTICES.md'
    $readme = Join-Path $stagingDirectory 'README.md'

    if (-not (Test-Path -LiteralPath $legacyProjectLicense)) {
        throw 'The audited companion archive does not contain its expected legacy LICENSE file.'
    }
    if (-not (Test-Path -LiteralPath $thirdPartyNotices)) {
        throw 'The audited companion archive does not contain THIRD_PARTY_NOTICES.md.'
    }
    if (-not (Test-Path -LiteralPath $readme)) {
        throw 'The audited companion archive does not contain README.md.'
    }

    Remove-Item -LiteralPath $legacyProjectLicense -Force
    Copy-Item -LiteralPath (Join-Path $repositoryDirectory 'LICENSE') `
        -Destination (Join-Path $stagingDirectory 'LICENSE.txt') -Force

    $licenseSummary = @'

## 라이선스 및 공식 배포

이 프로그램은 모든 기능을 무료로 사용할 수 있는 소스 공개형(Source-Available) 프리웨어이며 OSI 오픈소스가 아닙니다. 제작자의 허가 없는 수정본 배포, 재배포, 판매 및 상업적 이용을 금지합니다. 공식 배포처는 https://github.com/Spirit-Schema/tarkov-server-guard/releases 입니다. 비공식 배포본은 안전성과 정상 작동을 보증하거나 지원하지 않습니다. 자세한 조건은 `LICENSE.txt`, 제3자 고지는 `THIRD_PARTY_NOTICES.md`에서 확인할 수 있습니다.
'@
    Add-Content -LiteralPath $readme -Value $licenseSummary -Encoding UTF8

    if (Test-Path -LiteralPath $OutputArchive) {
        Remove-Item -LiteralPath $OutputArchive -Force
    }
    Compress-Archive -Path (Join-Path $stagingDirectory '*') `
        -DestinationPath $OutputArchive -CompressionLevel Optimal
}
finally {
    if (Test-Path -LiteralPath $stagingDirectory) {
        Remove-Item -LiteralPath $stagingDirectory -Recurse -Force
    }
}
