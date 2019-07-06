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

    public IamportViewManager(Activity activity, Context context) {
        _activity = activity;
        context = context;
        webView = new IamportWebView(_activity);

        webView.loadUrl("file:///android_asset/html/payment.html");
        webView.setWebChromeClient(new IamportWebChromeClient());
    }

    void resize(FrameLayout.LayoutParams params) {
        Log.d("###", String.valueOf(params.topMargin));
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
        JSONObject rootObject = new JSONObject();
        String pg = null;

        HashMap<String, Object> arg = (HashMap<String, Object>) methodCall.argument("data");
        try {
            pg = (String) arg.get("pay_method");
            rootObject.put("pay_method", (String) arg.get("pay_method"));
            rootObject.put("merchant_uid", (String) arg.get("merchant_uid"));
            rootObject.put("amount", (String) arg.get("amount"));
            rootObject.put("name", (String) arg.get("name"));
            rootObject.put("buyer_name", (String) arg.get("buyer_name"));
            rootObject.put("buyer_email", (String) arg.get("buyer_email") );
            rootObject.put("buyer_tel", (String) arg.get("buyer_tel"));
            rootObject.put("app_scheme", (String) arg.get("app_scheme"));

        } catch (JSONException e) {
            e.printStackTrace();
        }
        switch(pg) {
            case "nice": {
                webView.setWebViewClient(new NiceWebViewClient(context, _activity, methodCall));
                break;
            }
            default: {
                webView.setWebViewClient(new IamportWebViewClient(context, _activity, methodCall));
                break;
            }
        }
    }
}