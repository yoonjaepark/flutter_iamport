// https://docs.iamport.kr/tech/imp
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

  Params(this.pay_method, this.merchant_uid, this.amount, this.buyer_tel,
      {this.pg,
      this.escrow,
      this.name,
      this.custom_data,
      this.vat,
      this.currency,
      this.language,
      this.buyer_name,
      this.buyer_email,
      this.buyer_addr,
      this.buyer_postcode,
      this.notice_url,
      this.tax_free,
      this.display,
      this.digital,
      this.vbank_due,
      this.m_redirect_url,
      this.app_scheme,
      this.biz_num,
      this.popup});

  static Map<String, dynamic> toMap(Params json) {
    return {
      'pay_method': json.pay_method,
      'merchant_uid': json.merchant_uid,
      'amount': json.amount,
      'buyer_tel': json.buyer_tel,
      'pg': json.pg,
      'escrow': json.escrow,
      'name': json.name,
      'custom_data': json.custom_data,
      'vat': json.vat,
      'currency': json.currency,
      'language': json.language,
      'buyer_name': json.buyer_name,
      'buyer_email': json.buyer_email,
      'buyer_addr': json.buyer_addr,
      'buyer_postcode': json.buyer_postcode,
      'notice_url': json.notice_url,
      'tax_free': json.tax_free,
      'display': Display.toMap(json.display),
      'digital': json.digital,
      'vbank_due': json.vbank_due,
      'm_redirect_url': json.m_redirect_url,
      'app_scheme': json.app_scheme,
      'biz_num': json.biz_num,
      'popup': json.popup
    };
  }

  Params.fromJson(Map<String, dynamic> json) {
    this.pay_method = json['pay_method'];
    this.merchant_uid = json['merchant_uid'];
    this.amount = json['amount'];
    this.buyer_tel = json['buyer_tel'];
    this.pg = json['pg'];
    this.escrow = json['escrow'] ?? false;
    this.name = json['name'];
    this.custom_data = json['custom_data'];
    this.vat = json['vat'];
    this.currency = json['currency'];
    this.language = json['language'] ?? 'ko';
    this.buyer_name = json['buyer_name'];
    this.buyer_email = json['buyer_email'];
    this.buyer_addr = json['buyer_addr'];
    this.buyer_postcode = json['buyer_postcode'];
    this.notice_url = json['notice_url'];
    this.tax_free = json['tax_free'];
    this.display = Display(json['display']);
    this.digital = json['digital'] ?? false;
    this.vbank_due = json['vbank_due'];
    this.m_redirect_url = json['m_redirect_url'];
    this.app_scheme = json['app_scheme'];
    this.biz_num = json['biz_num'];
    this.customer_uid = json['customer_uid'];
    this.popup = json['popup'] ?? false;
    this.naverPopupMode = json['naverPopupMode'] ?? false;
  }
}

class ParamMaps {}

class Display {
  List<int> card_quota;

  Display(this.card_quota);

  static toMap(Display json) {
    return {'card_quota': json.card_quota};
  }
}
