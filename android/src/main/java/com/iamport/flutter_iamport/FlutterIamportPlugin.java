package com.iamport.flutter_iamport;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.util.Log;
import android.view.Display;
import android.widget.FrameLayout;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * FlutterIamportPlugin
 */
// implements MethodCallHandler
public class FlutterIamportPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  private Activity activity;
  private IamportViewManager iamportViewManager;
  private Context context;
  static MethodChannel channel;
  private static final String CHANNEL_NAME = "flutter_iamport";

  public FlutterIamportPlugin(Activity activity, Context activeContext) {
    this.activity = activity;
    this.context = context;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    final FlutterIamportPlugin instance = new FlutterIamportPlugin(registrar.activity(), registrar.activeContext());
    registrar.addActivityResultListener(instance);
    channel.setMethodCallHandler(instance);
  }

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    Log.d("###", methodCall.method);
    switch (methodCall.method) {
      case "showNativeView":
        if (iamportViewManager == null || iamportViewManager.closed == true) {
          iamportViewManager = new IamportViewManager(activity, context);
        }
        FrameLayout.LayoutParams params = buildLayoutParams(methodCall);

        activity.addContentView(iamportViewManager.webView, params);
        iamportViewManager.openUrl(methodCall);
        break;
      case "resize":
        resize(methodCall, result);
      case "close":
        if (iamportViewManager != null) {
          iamportViewManager.close(methodCall, result);
          iamportViewManager = null;
        }
        break;
      default:
        result.notImplemented();
        break;
    }

  }

  private void resize(MethodCall call, final MethodChannel.Result result) {
    if (iamportViewManager != null) {
      FrameLayout.LayoutParams params = buildLayoutParams(call);
      Log.d("###params", params.toString());
      iamportViewManager.resize(params);
    }
    result.success(null);
  }

  private FrameLayout.LayoutParams buildLayoutParams(MethodCall call) {
    Map<String, Number> rc = call.argument("rect");
    Log.d("###params", call.arguments.toString());

    FrameLayout.LayoutParams params;
    if (rc != null) {
      params = new FrameLayout.LayoutParams(
              dp2px(activity, rc.get("width").intValue()), dp2px(activity, rc.get("height").intValue()));
      params.setMargins(dp2px(activity, rc.get("left").intValue()), dp2px(activity, rc.get("top").intValue()),
              0, 0);
    } else {
      Display display = activity.getWindowManager().getDefaultDisplay();
      Point size = new Point();
      display.getSize(size);
      int width = size.x;
      int height = size.y;
      params = new FrameLayout.LayoutParams(width, height);
    }

    return params;
  }

  private int dp2px(Context context, float dp) {
    final float scale = context.getResources().getDisplayMetrics().density;
    return (int) (dp * scale + 0.5f);
  }


  @Override
  public boolean onActivityResult(int i, int i1, Intent intent) {
    return false;
  }

}
