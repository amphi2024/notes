# Amphi Notes에 기여하기

Amphi Notes를 개선하는 데에 도움을 주셔서 감사합니다. 개발자이시든, 번역가이시든, 문서 작성자이시든, 평범한 유저이든 상관없이 다양한 방식으로 기여하실 수 있습니다.

## 문제 제보

버그, 문제, 혹은 누락된 번역을 발견하신다면 언제든지 이메일로 연락하실 수 있습니다: support@amphi.site

버그를 제보하실 때에는, 해당 버그를 재현할 수 있는 방법도 함께 알려주세요.

## 번역하기

번역을 개선하고 싶지만 코드를 작성하고 싶지 않으시다면, [Weblate](https://hosted.weblate.org/projects/amphi-notes)에서 간편하게 번역에 참여하실 수 있습니다.

<a href="https://hosted.weblate.org/engage/amphi-notes/">
<img src="https://hosted.weblate.org/widget/amphi-notes/multi-auto.svg" alt="Translation status" />
</a>

## 개발자로서 시작하기

### 1. Flutter 설치
```bash
git clone https://github.com/flutter/flutter.git /path/to/your/flutter
cd /path/to/your/flutter
git checkout FLUTTER_VERSION # 권장된 버전은 pubspec.yaml 에 있습니다 (flutter: x.xx.x)
```
그 다음, 환경 변수를 설정해주세요:
```bash
export PATH="$PATH:/path/to/your/flutter/bin" # macOS 혹은 리눅스에서
# 윈도우에서는, 시스템 환경변수 설정으로 들어가서 %USERPROFILE%\path\to\your\flutter\bin 를 PATH에 추가해 주세요
# 세부정보: https://docs.flutter.dev/install
```

### 2. 앱 돌리기
```bash
flutter pub get
flutter run
```

준비되시면, Pull Request를 제출해주세요. 모든 기여에 저희는 감사하지만, 모든 Pull Request가 받아들여지지는 않을 수 있습니다.

## 개발자를 위한 기여가이드라인

Pull Request를 제출하실때, 다음과 같은 가이드라인을 따라주십시오:

- 하나의 함수에 너무 많은 변수와 긴 로직을 사용하는 것은 피해주세요.
- 직관적인 변수 및 함수 이름을 사용해주세요.
- 직관적인 커밋 메시지와 적절한 prefix를 붙여주세요 (예: feat, fix, docs)
- Pull Request는 작게, 하나의 변경사항에만 집중하게 만들어주세요.
- 경고 및 힌트가 뜨지 않도록 해주세요. 다만 프로젝트에 이미 존재하는 것과 동일한 종류라면 괜찮습니다.