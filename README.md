## Boopee
읽은 책에 대한 메모를 남기고 사람들과 공유하는 iOS 앱

- 팀원
    - 1인 개발
- 진행 기간
    - 개발: 2024.03.03 ~ 2024.04.22
<br/>

## 개발 환경 및 기술
- 개발 환경
    - Swift 5, xcode 15.0
    - 라이트/다크모드 지원, 가로모드 미지원
- Deployment Target
    - iOS 15.0
- 라이브러리
    - RxSwift, RxAlamofire, Kingfisher, SnapKit
- API
    - Kakao REST API
<br/>

## 아키텍처
![아키텍처 구조도](https://github.com/yunjikimm/Boopee/assets/68881093/c3e78a6c-2743-4a64-834e-0814eec9db91)
- MVVM 패턴
    - API 서버, DB의 서비스 로직과 UI 서비스 로직을 구분하기 위한 가독성 높은 MVVM 아키텍처 도입
- Input/Output
    - Input을 통해 ViewController로부터 전달받은 이벤트를 Binding
    - Output을 통해 ViewController에 데이터를 전달하도록 Binding
<br/>

## 주요 화면 및 기능
- `탐색`: 사람들이 남긴 메모를 탐색할 수 있습니다.
- `작성`: 책을 검색하고 메모를 작성할 수 있습니다.
- `마이페이지`: 내가 작성한 메모를 관리할 수 있습니다.

|`탐색`|
|:----:|
| <img src="https://github.com/yunjikimm/Boopee/assets/68881093/a44bafca-35de-4372-87ca-0417232a7db0" width="200"> |

|`책 검색`|`메모 작성`|
|:----:|:----:|
| <img src="https://github.com/yunjikimm/Boopee/assets/68881093/fc687848-bed8-4132-b5bb-e24aec853cd9" width="200"> | <img src="https://github.com/yunjikimm/Boopee/assets/68881093/5f08e28c-91ee-438b-bc59-bc4d32c2b3e2" width="200"> <img src="https://github.com/yunjikimm/Boopee/assets/68881093/71268955-d175-400d-8ecf-19de48095f00" width="200"> |

|`마이페이지 - 로그인 없음`|`마이페이지 - 로그인`|
|:----:|:----:|
| <img src="https://github.com/yunjikimm/Boopee/assets/68881093/fe353bab-df3a-48f0-8218-ae4e68010dc3" width="200"> <img src="https://github.com/yunjikimm/Boopee/assets/68881093/dcea15fa-9035-48bb-b982-e76c87247388" width="200"> | <img src="https://github.com/yunjikimm/Boopee/assets/68881093/47f5557e-c0b8-419b-bada-184bf3d7ad50" width="200"> |

|`메모 디테일`|`메모 삭제`|
|:----:|:----:|
| <img src="https://github.com/yunjikimm/Boopee/assets/68881093/def09836-fd04-41e9-8cd0-4e4d2a2cbfa7" width="200"> | <img src="https://github.com/yunjikimm/Boopee/assets/68881093/e45c3c43-aefd-49d3-bb96-797182535a11" width="200"> |

|`설정`|`웹뷰`|
|:----:|:----:|
| <img src="https://github.com/yunjikimm/Boopee/assets/68881093/d3ece224-da35-4f99-a1e6-f584d0f9d1f2" width="200"> <img src="https://github.com/yunjikimm/Boopee/assets/68881093/eb1c472c-3c06-47c2-97a9-8da32748de13" width="200"> | <img src="https://github.com/yunjikimm/Boopee/assets/68881093/60a3c939-bf31-4fe5-be08-4056b8ea0556" width="200"> |
