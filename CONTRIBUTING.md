# Contributing to Amphi Notes

Thanks for helping us improve Amphi Notes. You can contribute in many ways, whether you are a developer, translator, document writer, or just an ordinary user.

## Reporting Issues

If you find a bug, any issue, or missing translations, feel free to send us an email: support@amphi.site

If reporting a bug, please explain how to reproduce it.

## Getting Started for Developers

### 1. Install Flutter
```bash
git clone https://github.com/flutter/flutter.git /path/to/your/flutter
cd /path/to/your/flutter
git checkout FLUTTER_VERSION # recommended version is written in pubspec.yaml (flutter: x.xx.x)
```
Then, set the environment path for Flutter:
```bash
export PATH="$PATH:/path/to/your/flutter/bin" # for macOS or Linux
# For Windows, navigate to Environment Variables and add %USERPROFILE%\path\to\your\flutter\bin to your PATH
# For details: https://docs.flutter.dev/install
```

### 2. Run the Project
```bash
flutter pub get
flutter run
```

Once your changes are ready, create a pull request. We appreciate all contributions, but not all may be accepted.

## Contributing Guideline for Developers

When submitting a pull request to Amphi Notes, please follow these guidelines:

- Avoid using too many variables or writing overly long logic in a single function.
- Use intuitive variable and function names.
- Write clear commit messages with appropriate prefixes (e.g., feat, fix, docs).
- Keep pull requests small and focused.
- Avoid introducing new warnings or hints; existing ones of the same type are acceptable.