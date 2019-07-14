package com.iamport.flutter_iamport;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.CookieManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.FrameLayout;

import com.iamport.flutter_iamport.webviewclient.IamportWebViewClient;
import com.iamport.flutter_iamport.webviewclient.NiceWebViewClient;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import static android.app.Activity.RESULT_OK;

public class IamportViewManager {
    public static final String REACT_CLASS = "IamportWebView";
    boolean closed = false;
    WebView webView;
    Context context;
    Activity _activity;
    MethodChannel _channel;


    public IamportViewManager(Activity activity, Context context, MethodChannel channel) {
        _activity = activity;
        context = context;
        webView = new IamportWebView(_activity);
        _channel = channel;
        webView.loadUrl("file:///android_asset/html/payment.html");
        webView.setWebChromeClient(new IamportWebChromeClient());
    }

    void resize(FrameLayout.LayoutParams params) {
        webView.setLayoutParams(params);
    }

    void close(MethodCall call, MethodChannel.Result result) {
        if (webView != null) {
            ViewGroup vg = (ViewGroup) (webView.getParent());
            vg.removeView(webView);
        }
        webView = null;
        if (result != null) {
            result.success(null);
        }
        closed = true;
        FlutterIamportPlugin.channel.invokeMethod("onDestroy", null);
    }

    void openUrl(MethodCall methodCall) {
        String pg = null;

        HashMap<String, Object> arg = (HashMap<String, Object>) methodCall.argument("data");
        pg = (String) arg.get("pay_method");
        webView.getSettings().setJavaScriptEnabled(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            webView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        switch(pg) {
            case "nice": {
                webView.setWebViewClient(new NiceWebViewClient(context, _activity, methodCall, _channel));
                break;
            }
            default: {
                webView.setWebViewClient(new IamportWebViewClient(context, _activity, methodCall, _channel));
                break;
            }
        }
    }
}