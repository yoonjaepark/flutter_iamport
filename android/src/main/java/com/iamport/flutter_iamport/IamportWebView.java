package com.iamport.flutter_iamport;

import android.content.Context;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.CookieManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TextView;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import static io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class IamportWebView extends WebView {
    public IamportWebView(Context context) {
        super(context);
        setWebSettings();
        setCookieSettings();

        this.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // Enables debugging of web contents (HTML / CSS / JavaScript) loaded into any WebViews of this application
            this.setWebContentsDebuggingEnabled(true);
        }
    }

    public void setWebSettings() {
        /* Set web settings */
        WebSettings settings = this.getSettings();
        settings.setJavaScriptEnabled(true);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            // Configures the WebView's behavior when a secure origin attempts to load a resource from an insecure origin.
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }
    }

    public void setCookieSettings() {
        /* Set cookie  */
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        cookieManager.setAcceptFileSchemeCookies(true); // add default cookie support
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            cookieManager.setAcceptThirdPartyCookies(this, true);
        }
    }
}