import 'package:flutter_iamport/constants/index.dart';
import 'package:flutter_iamport/model/Params.dart';

Map<String, dynamic> validateProps(userCode, Params data) {
  if (userCode == '' || userCode == null) {
    return {'validate': false, 'message': '가맹점 식별코드(userCode)는 필수입력입니다.'};
  }
  if (data == null) {
    return {'validate': false, 'message': '결제 파라미터(data)는 필수입력입니다.'};
  }
  if (data.merchant_uid == '' || data.merchant_uid == null) {
    return {'validate': false, 'message': '주문번호(merchant_uid)는 필수입력입니다.'};
  }
  if (data.amount == null || data.amount == null) {
    return {'validate': false, 'message': '결제금액(amount)은 필수입력입니다.'};
  }
  if (data.buyer_tel == '' || data.buyer_tel == null) {
    return {'validate': false, 'message': '구매자 번호(buyer_tel)는 필수입력입니다.'};
  }
  if (data.app_scheme == '' || data.app_scheme == null) {
    return {'validate': false, 'message': 'app_scheme은 필수입력입니다.'};
  }
  if ((data.language == '' || data.language == null) && data.pg != 'paypal') {
    if (EN_AVAILABLE_PG.indexOf(data.pg) != -1) {
      if (LANGUAGE.indexOf(data.language) != -1) {
        return {
          'validate': false,
          'message': '올바르지 않은 언어 설정입니다.\n 선택하신 PG사는 ko 또는 en 옵션을 지원합니다. '
        };
      }
    } else if (data.language != 'ko') {
      return {
        'validate': false,
        'message': '올바르지 않은 언어 설정입니다.\n 선택하신 PG사는 ko 옵션만 지원합니다.'
      };
    }
  }
  if (data.pay_method == 'phone' && !data.digital) {
    return {'validate': false, 'message': '휴대폰 소액결제시 digital은 필수입력입니다.'};
  }
  if (data.pg == 'eximbay') {
    return {'validate': false, 'message': '해당 모듈은 현재 엑심베이 지원을 위한 개발을 진행중입니다.'};
  }
  if (data.pg == 'syrup') {
    return {'validate': false, 'message': '해당 모듈은 현재 시럽페이를 지원하지 않습니다.'};
  }
  if (data.pg == 'paypal' && data.popup == true) {
    return {'validate': false, 'message': '해당 모듈에서 popup은\n페이팔 결제시 지원하지 않습니다.'};
  }
  if ((data.pg == 'naverpay' || data.pg == 'naverco') &&
      data.naverPopupMode == true) {
    return {
      'validate': false,
      'message': '해당 모듈에서 popup은\n네이버 페이 결제시 지원하지 않습니다.'
    };
  }
  if (data.pg == 'danal_tpay' &&
      data.pay_method == 'vbank' &&
      data.biz_num == null) {
    return {'validate': false, 'message': '다날-가상계좌시 biz_num은 필수입력입니다.'};
  }
  if ((data.pg == 'kcp_billing' || data.pg == 'syrup') &&
      data.customer_uid == null) {
    return {'validate': false, 'message': '정기결제시 customer_uid는 필수입력입니다.'};
  }

  return {'validate': true, 'message': ''};
}
