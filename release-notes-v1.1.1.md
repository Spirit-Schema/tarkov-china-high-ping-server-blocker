## 후속 통합 도구

이 프로젝트의 기능을 확장한 [최신 Tarkov Server Guard](https://github.com/Spirit-Schema/tarkov-server-guard/releases/latest)가 공개되었습니다. EFT·Arena 접속 기록, 핑·지역 조회, 서버별 차단·해제와 차단 현황을 한곳에서 확인할 수 있어 신규 사용자는 Server Guard를 권장합니다.

---

## 변경 사항

- 실제 고핑이 확인된 `209.58.188.216` 하나만 차단합니다.
- v1.1.0의 관찰 후보였던 `209.58.190.117`, `209.58.191.183`은 차단 대상에서 제거했습니다.
- 새 적용 파일을 실행하면 기존 두 후보 규칙도 자동으로 삭제됩니다.
- 기존 원상복구 파일은 그대로 사용할 수 있으며 현재·구버전 규칙을 모두 삭제합니다.

## 기존 v1.1.0 사용자

기존 차단을 먼저 해제하지 말고 새 `ExcludeChinaHighPingServer.exe`를 한 번 실행하면 됩니다. 실행 후 `209.58.188.216` 규칙 하나만 남습니다.

## 접속이 차단될 때

`209.58.188.216` 레이드에 배정되면 다른 서버로 자동 재배정되지 않고 `Server Connection Lost`가 표시됩니다.

**재접속을 누르지 말고 `나가기 확인`을 누른 뒤 다시 매칭하세요.**

실제 테스트에서는 이 절차로 레이드에 입장하지 않은 상태에서 출발 전 장비가 유지됐습니다.

## 접속 서버 핑 확인 도구 (선택)

`TarkovServerPingChecker-v0.3.0.zip`은 EFT 로그에서 최근 접속 서버를 찾아 핑과 추정 지역을 확인하는 보조 도구입니다.

- 최근 로그 세션 최대 100개를 검사하고 서버 IP가 기록된 세션만 표시합니다.
- 화면 상단에는 배포 버전 `v0.3.0`을 표시합니다.
- `전체 핑·지역 조회`를 누르면 고유 서버 IP의 평균 핑과 추정 지역을 한 번에 확인합니다.
- 평균 핑은 100ms 미만 초록색, 100~149ms 노란색, 150ms 이상 빨간색으로 표시합니다.
- 관리자 권한이나 패킷 캡처가 필요하지 않으며 방화벽 규칙을 만들거나 변경하지 않습니다.
- Windows의 .NET Framework 4.8 환경에서 실행됩니다.

### 사용 방법

1. ZIP 압축을 해제합니다.
2. `TarkovServerPingChecker.exe`를 실행합니다.
3. EFT 로그 경로를 확인하고 필요하면 `폴더 선택` 후 `경로 적용`을 누릅니다.
4. `전체 핑·지역 조회`를 눌러 결과를 확인합니다.

> 지역 조회 시 게임 서버 IP가 `ipwho.is`에 전달됩니다. 게임 로그 내용과 로컬 경로는 전송하지 않습니다. IP 기반 지역은 실제 서버 장비 위치와 다를 수 있습니다.

> ICMP 핑은 실제 레이드의 게임 핑과 다를 수 있으며, ICMP를 차단하는 서버는 응답 없음으로 표시될 수 있습니다.

## 라이선스 및 공식 배포

- 모든 기능을 무료로 사용할 수 있는 프리웨어입니다.
- 소스는 안전성과 투명성 확인을 위해 공개하지만 OSI 오픈소스는 아닙니다.
- 제작자의 허가 없는 수정본 배포, 재배포, 판매 및 상업적 이용을 금지합니다.
- 공식 배포처는 [Spirit-Schema GitHub Releases](https://github.com/Spirit-Schema/tarkov-server-guard/releases)입니다.
- 비공식 배포본은 안전성과 정상 작동을 보증하거나 지원하지 않습니다.
- 제3자 구성요소는 각각의 기존 라이선스를 따릅니다.

배포 ZIP에는 `LICENSE.txt`와 `THIRD_PARTY_NOTICES.md`가 포함됩니다.

## SHA-256

- `ExcludeChinaHighPingServer.exe`: `fdc8d27739f9862bd780c31d65121fb42ebbd51edbfda6f68aeafca8e5bb020e`
- `ExcludeChinaHighPingServer_Delete.exe`: `a9cec8c1ce983c0cc0d5e92fce9cfe7fd0e79c73f0af405083695a27797231df`
- `Tarkov-China-High-Ping-Server-Blocker-v1.1.1.zip`: `02c5ca49e89be5f1ae7e61a90fc9e2db9e2ba103366bbc8228884502bb002eff`
- `Tarkov-China-High-Ping-Server-Blocker-Source-v1.1.1.zip`: `317210e8b7aa9c192867ee97f55d98f76b877a016e589e737a2c7aae2741ec95`
- `TarkovServerPingChecker-v0.3.0.zip`: `3f5349cef2394e2337d642cd91dcbd71838996dba32a7af7caacd05a5255e176`
- `LICENSE.txt`: `ff28f3af5fd5de0039e780fab3fe8a6b358972fc203f62af04ad3e9d892037b1`
- `THIRD_PARTY_NOTICES.md`: `07635bcc5caa33e9816413352886476fd39e9bb9e7d278d878f772c9dad9a601`
- `README.md`: `d03cc8e820ef91feda65c7cbb182c55b2863c0be8a7d87bad02baeb5a651bd23`
