
package com.iamport.flutter_iamport.webviewclient;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.os.Build;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

//import com.facebook.react.bridge.ReadableMap;
//import com.facebook.react.bridge.ReadableMapKeySetIterator;
//import com.facebook.react.bridge.ReadableType;
//import com.facebook.react.uimanager.ThemedReactContext;
//import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONStringer;

import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class IamportWebViewClient extends WebViewClient {
  protected Context reactContext;
  protected Activity activity;

  private String userCode;
  private JSONObject data;
  private String callback;
  private String triggerCallback;
  protected String appScheme;
  private MethodChannel channel;
  private Boolean loadingFinished = false;

  private static final String DEFAULT_REDIRECT_URL_WHEN_SUCCESS = "https://service.iamport.kr/payments/success";
  private static final String DEFAULT_REDIRECT_URL_WHEN_FAILURE = "https://service.iamport.kr/payments/fail";



  public IamportWebViewClient(Context reactContext, Activity activity, MethodCall methodCall, MethodChannel channel) {
    this.reactContext = reactContext;
    this.activity = activity;
    this.data = new JSONObject();
    this.channel = channel;

    HashMap<String, Object> arg = methodCall.argument("data");
    try {
      userCode = "iamport";
      data.put("pg", (String) arg.get("pg"));

      data.put("pay_method", (String) arg.get("pay_method"));
      data.put("merchant_uid", (String) arg.get("merchant_uid"));
      data.put("amount", (String) arg.get("amount"));
      data.put("name", (String) arg.get("name"));
      data.put("buyer_name", (String) arg.get("buyer_name"));
      data.put("buyer_email", (String) arg.get("buyer_email") );
      data.put("buyer_tel", (String) arg.get("buyer_tel"));
      data.put("app_scheme", (String) arg.get("app_scheme"));

    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  @Override
  public boolean shouldOverrideUrlLoading(WebView view, String url) {

    if (isPaymentOver(url)) { // 결제시도가 종료된 후, 콜백이 설정되었으면, 리액트 네이티브로 event dispatch
      Uri uri = Uri.parse(url);
      Log.d("shouldOverrid", url.toString());
      Log.d("shouldOverrid", uri.getPath());
      Log.d("shouldOverrid", uri.getAuthority());
      Log.d("shouldOverrid", uri.getEncodedQuery());

      this.channel.invokeMethod("onState", uri.getEncodedQuery());
      return false;
    }
    if (isUrlStartsWithProtocol(url)) return false;

    Intent intent = null;
    try {
      beforeStartNewActivity();

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
        intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME); // Intent URI 처리
      }
      if (intent == null) return false;

      startNewActivity(intent.getDataString());
      return true;
    } catch(URISyntaxException e) {
      return false;
    } catch(ActivityNotFoundException e) { // PG사에서 호출하는 url에 package 정보가 없는 경우
      String scheme = intent.getScheme();
      if (isPaymentSchemeNotFound(scheme)) return true;

      String packageName = intent.getPackage();
      if (packageName == null) return false;

      startNewActivity("market://details?id=" + packageName);
      return true;
      }
  }

  /* WebView가 load되면 IMP.init, IMP.request_pay를 호출한다 */
  @Override
  public void onPageFinished(WebView view, String url) {
    if (!loadingFinished && Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) { // 무한루프 방지
      setCustomLoadingPage(view);

      view.getSettings().setJavaScriptEnabled(true);
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        view.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
      }
      view.evaluateJavascript("IMP.init('" + userCode + "');", null);
      view.evaluateJavascript("IMP.request_pay(" + data + ", " + triggerCallback + ");", null);

      loadingFinished = true;
    }
  }

  /* 커스텀 로딩화면 셋팅 */
  private void setCustomLoadingPage(WebView view) {
    String image = "";
    String message = "";
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      view.evaluateJavascript("document.getElementById('imp-rn-img').src = '" + image + "';", null);
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      view.evaluateJavascript("document.getElementById('imp-rn-msg').innerText = '" + message + "';", null);
    }
  }

  /* url이 https, http 또는 javascript로 시작하는지 체크 */
  private boolean isUrlStartsWithProtocol(String url) {
    if (url.startsWith("https://") || url.startsWith("http://") || url.startsWith("javascript:")) return true;
    return false;
  }

  /* 결제가 종료되었는지 여부를 판단한다 */
  private boolean isPaymentOver(String url) {
    if (
      url.startsWith(DEFAULT_REDIRECT_URL_WHEN_FAILURE) ||
      url.startsWith(DEFAULT_REDIRECT_URL_WHEN_SUCCESS)
    ) return true;

    return false;
  }

  /* 나이스 정보통신 실시간 계좌이체 예외처리 등 */
  protected void beforeStartNewActivity() {

  }

  protected void startNewActivity(String parsingUri) {
    Uri uri = Uri.parse(parsingUri);
    Intent newIntent = new Intent(Intent.ACTION_VIEW, uri);

    this.activity.startActivity(newIntent);
  }

  /* ActivityNotFoundException에서 market 실행여부 확인 */
  protected boolean isPaymentSchemeNotFound(String scheme) {
    return false;
  }
}
