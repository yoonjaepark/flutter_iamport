# flutter_iamport
[![Build Status](https://img.shields.io/badge/pub-v0.0.1-success.svg)](https://travis-ci.org/roughike/flutter_iamport)

Android 및 iOS에서 iamport를 사용하여 결제 할 때 사용하는 Flutter 플러그인입니다.

## 기능 구현 예정 리스트

- 나이스 페이
- 휴대폰 본인 인증
- 코드 최적화

## 설치

어플리케이션을 실행하려면 Flutter 프로젝트에서 pubspec 의존성을 선언해야합니다. 또한 일부 최소 Android 및 iOS 특정 구성을 완료해야합니다. 앱이 다운 될 수 있습니다.

## Flutter 프로젝트

pub의 설치 지침을 참조하십시오.

## 설정(Android)
In order to use the iamport interworking module in iOS, you need to set the following items.
#### AndroidManifest permission

```html
  <uses-permission android:name="android.permission.INTERNET" />
    <application
        android:usesCleartextTraffic="true" tools:targetApi="28" tools:ignore="GoogleAppIndexingWarning"
        android:icon="@mipmap/ic_launcher">
        ...
```

## Seeting(IOS)
iOS에서 iamport 연동 모듈을 사용하려면 다음 3 가지 항목을 설정해야합니다.

#### 1. App Scheme Setting
외부 결제 애플리케이션 (예 : PACO, ShinhanPanPay)에서 결제 후 반환 할 때 사용할 URL 식별자를 설정해야합니다.

```html
<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>flutter_iamport_example</string>
			</array>
		</dict>
	</array>
```

#### 2. 외부 앱 목록 등록
타사 앱 (예) 외부 앱 목록을 등록해야 앱을 실행할 수 있습니다.

```html
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>kakao0123456789abcdefghijklmn</string>
  <string>kakaokompassauth</string>
  <string>storykompassauth</string>
  <string>kakaolink</string>
  <string>kakaotalk</string>
  <string>kakaostory</string>
  <string>storylink</string>
  <string>payco</string>
  <string>kftc-bankpay</string>
  <string>ispmobile</string>
  <string>itms-apps</string>
  <string>hdcardappcardansimclick</string>
  <string>smhyundaiansimclick</string>
  <string>shinhan-sr-ansimclick</string>
  <string>smshinhanansimclick</string>
  <string>kb-acp</string>
  <string>mpocket.online.ansimclick</string>
  <string>ansimclickscard</string>
  <string>ansimclickipcollect</string>
  <string>vguardstart</string>
  <string>samsungpay</string>
  <string>scardcertiapp</string>
  <string>lottesmartpay</string>
  <string>lotteappcard</string>
  <string>cloudpay</string>
  <string>nhappvardansimclick</string>
  <string>nonghyupcardansimclick</string>
  <string>nhallonepayansimclick</string>
  <string>citispay</string>
  <string>citicardappkr</string>
  <string>citimobileapp</string>
  <string>itmss</string>
  <string>lpayapp</string>
  <string>kpay</string>
</array>
```

#### 3. App Transport Security Setting

```html
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoadsInWebContent</key>
  <true/>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

## example

#### 1. 일반 / 정기 결제 사용 예
```dart
import 'package:flutter/material.dart';
import 'package:flutter_iamport/iamport_view.dart'; // 아임포트 결제모듈을 불러옵니다.

class Payment extends StatelessWidget {
    callback(String url) { /* [필수입력] 결제 종료 후, 라우터를 변경하고 결과를 전달합니다. */
        Map<String, dynamic> args = {
        'success' :  Uri.splitQueryString(url)['success'],
        'impUid' : Uri.splitQueryString(url)['imp_uid'],
        'errorMsg' : Uri.splitQueryString(url)['error_msg'],
        };
        Navigator.pushReplacementNamed(context, '/PaymentResult', arguments: args);
    }



      /* [필수입력] 결제에 필요한 데이터를 입력합니다. 추후 인터페이스 추가 */
     Map<String, dynamic> state = {
        'pg': 'html5_inicis',
        'payMethod': 'card',
        'name': '아임포트 결제데이터 분석',
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}',
        'app_scheme': 'example',
        'amount': '39000',
        'buyerName': '홍길동',
        'buyerTel': '01012345678',
        'buyerEmail': 'example@naver.com',
        'buyerAddr': '서울시 강남구 신사동 661-16',
        'buyerPostcode': '06018',
        'cardQuota': 0,
        'vbankDue': null,
        'bizNum': null,
        'digital': null,
        'escrow': null,
    };

    @override
    Widget build(BuildContext context) {
        return IamportView(
            appBar: new AppBar(
            title: const Text('Pament'),
            ),
            param: data,
            userCode: "iamport",
            callback: this.callback);
    }
}
```