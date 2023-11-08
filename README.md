# MILLIONZ 회원등록 앱 클론 코딩

이 프로젝트는 아토스터디의 사전 과제입니다. 주어진 디자인과 API를 바탕으로 회원 등록 기능을 구현한 네 개의 화면으로 구성된 iOS 앱을 개발했습니다.

## 기술 스택
- **언어**: Swift
- **UI**: UIKit, storyboard, xib, snapkit
- **MVVM 바인딩**: RxSwift, RxCocoa
- **API**: 아토스터디에서 제공
- **최소 버전**: ios 15.0

## 구현동작
- ### SNS 선택 화면
![ezgif com-video-to-gif (4)](https://github.com/cwh2626/MILLIONZ_cloneCoding/assets/52994666/fb1c2940-7d78-4d26-95e8-6910e7a32c6f)
---
- ### 닉네임 입력 화면
![ezgif com-video-to-gif (3)](https://github.com/cwh2626/MILLIONZ_cloneCoding/assets/52994666/8e3616da-c88a-441d-b041-6d40f1c5604e)
---
- ### 캐릭터 선택 화면
![ezgif com-video-to-gif (2)](https://github.com/cwh2626/MILLIONZ_cloneCoding/assets/52994666/039984a8-09e8-4068-ba08-0e1dbb240179)
---
- ### 로그아웃
![ezgif com-video-to-gif (1)](https://github.com/cwh2626/MILLIONZ_cloneCoding/assets/52994666/00b151e7-6f80-4e2a-ac3f-c638e7bc6ef4)
---
- ### 닉네임 중복
![ezgif com-video-to-gif](https://github.com/cwh2626/MILLIONZ_cloneCoding/assets/52994666/dbedc697-b4db-4a43-82dd-4d5f984b589a)

---
## 실행 방법

이 프로젝트를 실행하기 위해서는 몇 가지 사전 준비가 필요합니다. 

1. **프로젝트 클론하기**

2. **환경 설정 파일 추가하기**
    설정 파일 `Config.xcconfig`를 필요로 합니다. 이 파일에는 API 토큰과 URL 정보가 포함되어 있습니다. 파일 구성은 다음과 같습니다

    ```
    // Config.xcconfig
    API_TOKEN = API_토큰을_입력하세요
    API_URL = API의_URL을_입력하세요
    ```

