# Tarkov China High-Ping Server Blocker

Escape from Tarkov의 China 지역 안에서 특정 회선에 높은 지연을 유발하는 것으로 의심되는 서버 IP만 Windows 방화벽으로 차단하거나 차단 해제하는 작은 Windows 도구입니다.

이 도구는 Battlestate Games 또는 Escape from Tarkov의 공식 도구가 아닙니다. 서버 IP와 매칭 방식은 예고 없이 바뀔 수 있으며, 차단된 서버에 레이드가 이미 배정되면 `Server Connection Lost`가 발생할 수도 있습니다.

## 다운로드 및 사용

GitHub의 **Releases**에서 다음 파일을 다운로드합니다.

- `ExcludeChinaHighPingServer.exe`: 차단 적용
- `ExcludeChinaHighPingServer_Delete.exe`: 이 도구가 만든 차단 규칙 삭제(원상복구)

두 파일 모두 Windows 방화벽을 변경하기 위해 관리자 권한을 요청합니다. 로컬에서 빌드한 코드 서명 없는 실행 파일이므로 Windows SmartScreen 경고가 표시될 수 있습니다.

## 차단 대상

각 IP는 독립된 송신(Outbound) 차단 규칙으로 생성됩니다.

| IP | 방화벽 규칙 이름 |
| --- | --- |
| `209.58.188.216` | `EFT_ExcludeChinaHighPingServer_209.58.188.216` |
| `209.58.190.117` | `EFT_ExcludeChinaHighPingServer_209.58.190.117` |
| `209.58.191.183` | `EFT_ExcludeChinaHighPingServer_209.58.191.183` |

적용 파일을 반복 실행해도 규칙은 중복되지 않습니다. 삭제 파일은 위의 정확한 규칙 이름 세 개만 찾아 제거하며 다른 Windows 방화벽 규칙은 수정하거나 삭제하지 않습니다.

## 변경하지 않는 항목

- Escape from Tarkov 및 Battlestate Games 설치 파일
- `hosts` 파일
- DNS 설정
- 라우팅 테이블
- 공유기 설정
- 다른 Windows 방화벽 규칙

## 소스에서 빌드

Windows 10/11과 .NET Framework의 기본 C# 컴파일러를 사용합니다. 별도 NuGet 패키지는 필요하지 않습니다.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\build.ps1
```

빌드 결과는 `dist` 폴더에 생성됩니다.

```text
dist\ExcludeChinaHighPingServer.exe
dist\ExcludeChinaHighPingServer_Delete.exe
dist\SHA256SUMS.txt
```

## 알려진 제한

- 방화벽 차단이 항상 다른 게임 서버로 재배정된다는 공식 보장은 없습니다.
- 다른 통신사 또는 지역에서는 해당 IP의 지연 상태가 다를 수 있습니다.
- 서버 제공업체와 IP가 변경되면 목록을 갱신해야 합니다.
- 실행 파일에는 코드 서명이 없습니다.

문제가 생기면 `ExcludeChinaHighPingServer_Delete.exe`를 실행해 이 도구가 만든 규칙을 모두 제거할 수 있습니다.

## 라이선스

현재 별도의 오픈소스 라이선스를 부여하지 않았습니다. 소스 코드는 동작 확인과 투명성을 위해 공개되어 있습니다.

