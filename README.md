# network_flutter

HTTP Network Request module for Sugar Foundation projects

## Introduction

Based on Dio package [Dio](https://pub.dev/packages/dio)

## Getting Started

Add the dependency in your project's 'pubspec.yaml' file.

```yaml

  network_flutter:
    git: https://github.com/Sugar-Foundation/network_flutter

```

Before using the 'Request', you need to setup the api 'baseUrl' endpoint.

```dart

Request().setup('https://api.xxx.com/api');

```

To send a request simply call the needed method.

```dart

Request().getValue('https://api.xxx.com/api/time');

```