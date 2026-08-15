# Tarkov China High-Ping Server Blocker

> [!IMPORTANT]
> 이 프로젝트의 후속 통합 도구는 [Tarkov Server Guard](https://github.com/Spirit-Schema/tarkov-server-guard)입니다. EFT·Arena 접속 기록, 핑·지역 조회, 서버별 차단·해제와 차단 현황을 한곳에서 제공합니다. 신규 사용자는 [최신 Server Guard 릴리스](https://github.com/Spirit-Schema/tarkov-server-guard/releases/latest)를 권장합니다.

Escape from Tarkov의 China 지역에서 고핑이 확인된 서버 `209.58.188.216`으로 향하는 송신 연결만 Windows 방화벽으로 차단하거나 원상복구하는 작은 Windows 도구입니다.

이 도구는 Battlestate Games 또는 Escape from Tarkov의 공식 도구가 아닙니다.

## 다운로드 및 사용

GitHub의 **Releases**에서 다음 파일을 다운로드합니다.

- `ExcludeChinaHighPingServer.exe`: 차단 적용
- `ExcludeChinaHighPingServer_Delete.exe`: 이 도구가 만든 차단 규칙 삭제(원상복구)

두 파일 모두 Windows 방화벽을 변경하기 위해 관리자 권한을 요청합니다. 로컬에서 빌드한 코드 서명 없는 실행 파일이므로 Windows SmartScreen 경고가 표시될 수 있습니다.

### 차단 적용 및 레이드 접속 방법

1. `ExcludeChinaHighPingServer.exe`를 실행하고 관리자 권한 요청을 승인합니다.
2. China 서버 매칭에서 `209.58.188.216` 레이드에 배정되면 다른 서버로 자동 재배정되지 않고 실제 레이드 접속이 차단되어 `Server Connection Lost`가 표시됩니다.
3. 이 화면에서는 **재접속을 누르지 말고 `나가기 확인`을 누릅니다.**
4. 로비로 돌아온 뒤 다시 매칭합니다.

실제 테스트에서는 위 절차로 레이드에 입장하지 않은 상태에서 출발 전 장비가 유지되는 것을 확인했습니다.

### v1.1.0 기존 사용자

기존 차단을 먼저 해제할 필요 없이 새 `ExcludeChinaHighPingServer.exe`를 한 번 실행하면 됩니다. 새 버전은 v1.1.0에서 사용한 다음 두 관찰 후보 규칙을 자동으로 삭제하고 `209.58.188.216` 규칙 하나만 적용합니다.

- `209.58.190.117`
- `209.58.191.183`

기존 `ExcludeChinaHighPingServer_Delete.exe`도 그대로 사용할 수 있습니다.

### 원상복구

`ExcludeChinaHighPingServer_Delete.exe`를 실행하면 현재 차단 규칙과 v1.1.0의 기존 규칙을 모두 찾아 삭제합니다. 다른 Windows 방화벽 규칙은 수정하거나 삭제하지 않습니다.

## 차단 대상

| IP | 방화벽 규칙 이름 |
| --- | --- |
| `209.58.188.216` | `EFT_ExcludeChinaHighPingServer_209.58.188.216` |

적용 파일을 반복 실행해도 규칙은 중복 생성되지 않습니다.

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

- 다른 통신사 또는 지역에서는 해당 IP의 지연 상태가 다를 수 있습니다.
- 서버 제공업체와 IP가 변경되면 목록을 갱신해야 합니다.
- 실행 파일에는 코드 서명이 없습니다.

문제가 생기면 `ExcludeChinaHighPingServer_Delete.exe`를 실행해 이 도구가 만든 규칙을 모두 제거할 수 있습니다.

## 라이선스

현재 별도의 오픈소스 라이선스를 부여하지 않았습니다. 소스 코드는 동작 확인과 투명성을 위해 공개되어 있습니다.
