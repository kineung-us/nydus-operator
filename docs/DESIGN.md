# Design goal

## external controller

publish-pubsub 세팅이 필요없음.

현재 deploy에 spec 에서 반영해야 할 파라미터의 특성은 총 5개

1. 필수값. 없으면 에러 출력
1. 기본값이 있고, 설정시 적용됨.
1. 기본값이 다른 값을 참조하고 설정시 적용됨.
1. 기본값이 다른 값을 참조하고 설정은 무시함.
1. 기본값이 없고, 설정시 적용됨. 

작성 하고 보니 3개로 줄일 수 있음.

1. 필수값. 없으면 에러 출력
1. 기본값(다른값 참조 포함). 설정시 적용됨.
1. 기본값(다른값 참조 포함). 설정시 무시함.

필수값 처리의 단계

1. 기본값 "" 으로 작성
1. 리소스 값을 추가함
1. 그럼에도 불구하고 값이 "" 와 같다면 에러

기본값. 설정시 적용됨 처리의 단계

1. 기본값을 default 에 작성
1. 리소스 값을 추가함.
1. 다른 처리 없음.

기본값. 설정시 무시함 처리의 단계

(이거 고민해야 함.)

1. 기본값을 default 에 작성
1.1 리소스 값을 추가함.
1.1 다시 기본값을 추가함.

1.2 리소스 값에서 설정 무시 컬럼을 제거
1.2 리소스 값을 추가함


기본값 없음. 

어떻게 추가할 것인가?

1. default에 컬럼도 작성하지 않음.
1. 리소스 값을 추가함.


## injector

"nydus.mrchypark.github.io/enabled"
"nydus.mrchypark.github.io/http-port"
"nydus.mrchypark.github.io/publish-pubsub-name"
"nydus.mrchypark.github.io/publish-pubsub-ttl-seconds"
"nydus.mrchypark.github.io/subscribe-pubsub-name"
"nydus.mrchypark.github.io/subscribe-topic-name"
"nydus.mrchypark.github.io/target-root"
"nydus.mrchypark.github.io/target-version"
"nydus.mrchypark.github.io/invoke-timeout-seconds"
"nydus.mrchypark.github.io/publish-timeout-seconds"
"nydus.mrchypark.github.io/callback-timeout-seconds"

## 설계

operator 에서는 기본값을 처리하지 않음.
기본값 처리는 앱에 기록하고 처리함.
필수값은 에러 메세지 출력후 종료.
