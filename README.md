# flutter_iamport
[![Build Status](https://img.shields.io/badge/pub-v0.0.6-success.svg)](https://travis-ci.org/roughike/flutter_iamport)

A Flutter plugin for using the iamport for payment on Android and iOS.

## List of features

- Nice pay
- Authenticate for phone
- Code optimization

## Installation

To get things up and running, you'll have to declare a pubspec dependency in your Flutter project. Also some minimal Android & iOS specific configuration must be done, otherise your app will crash.

## On your Flutter project

See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_iamport#-installing-tab-)

## Seeting(Android)
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
In order to use the iamport interworking module in iOS, you have to set the following 3 items.

#### 1. App Scheme Setting
You need to set the URL identifier to use when returning after payment in the external payment application (eg PACO, ShinhanPanPay).

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

#### 2. Registration of external app list
3rd party app(example) You need to register your external apps list so that you can run it

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

## model
``` dart
class Params {
  String pg;
  String pay_method;
  bool escrow;
  String merchant_uid;
  String name;
  int amount;
  Object custom_data;
  int tax_free;
  int vat;
  String currency;
  String language;
  String buyer_name;
  String buyer_tel;
  String buyer_email;
  String buyer_addr;
  String buyer_postcode;
  String notice_url;
  Display display;

  bool digital;
  String vbank_due;
  String m_redirect_url;
  String app_scheme;
  String biz_num;

  String customer_uid;
  bool popup;
  bool naverPopupMode;

  static Map<String, dynamic> toMap(Params json) {
    return {
      'pay_method': json.pay_method,
      'merchant_uid': json.merchant_uid,
      'amount': json.amount,
      ...
  }

  Params.fromJson(Map<String, dynamic> json) {
    this.pay_method = json['pay_method'];
    this.merchant_uid = json['merchant_uid'];
    this.amount = json['amount'];
    ...
  }
```

## example

#### 1. Common / Regular billing usage example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_iamport/iamport_view.dart'; // Import iamport payment module.
import 'package:flutter_iamport/model/Params.dart';

class Payment extends StatelessWidget {
    callback(String url) { /* [Required] After the payment is finished, change the router and deliver the result. */
        Map<String, dynamic> args = {
        'success' :  Uri.splitQueryString(url)['success'],
        'impUid' : Uri.splitQueryString(url)['imp_uid'],
        'errorMsg' : Uri.splitQueryString(url)['error_msg'],
        };
        Navigator.pushReplacementNamed(context, '/PaymentResult', arguments: args);
    }



    /* [Required] Enter the data required for payment. */    
    Params state = Params.fromJson({
      'pg': 'html5_inicis',
      'pay_method': 'card',
      'name': '아임포트 결제데이터 분석',
      'merchant_uid': 'mid_${DateTime.now().millisecondsSinceEpoch}',
      'app_scheme': 'example',
      'amount': 39000,
      'buyer_name': '홍길동',
      'buyer_tel': '01012345678',
      'buyer_email': 'example@naver.com',
      'buyer_addr': '서울시 강남구 신사동 661-16',
      'buyer_postcode': '06018',
    });

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