import Flutter
import UIKit

public class SwiftFlutterIamportPlugin: NSObject, FlutterPlugin {
    var iamportView: IamportViewController? = nil
    let viewController = UIViewController()
    var iamportResult: FlutterResult? = nil
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "flutter_iamport", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterIamportPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.iamportResult = result
        if call.method == "showNativeView" {
            self.iamportView = IamportViewController()
            
            DispatchQueue.main.async {
                guard let args = call.arguments else {
                    return
                }
                if let myArgs = args as? [String: Any],
                    let rect = myArgs["rect"] as? Dictionary<String, Int>,
                    let param = myArgs["data"] as? [String: String]{
                    self.iamportView!.rect = self.parseRect(rect: rect)
                    self.iamportView!.param = asString(jsonDictionary: param)
                } else {
                }
                UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self.iamportView!.view);
            }
        } else if call.method == "resize" {
            print(call.method)
        } else if call.method == "close" {
            print(call.method)
            
            self.closeWebView()
            
        }
        
    }
    
    public func closeWebView() {
        if (self.iamportView != nil) {
            print("closeWebView")
            self.iamportView!.webView.stopLoading()
            self.iamportView!.webView.removeFromSuperview()
            self.iamportView!.webView.navigationDelegate = nil
            //            self.iamportView!.webView.removeObserver(self, forKeyPath: "estimatedProgress")
            self.iamportView!.webView = nil;
            self.iamportView = nil;
            self.iamportResult!(nil)
        }
    }
    
    public func parseRect(rect: Dictionary<String, Int>) -> CGRect {
        return CGRect(x: rect["left"] ?? 0, y: rect["top"] ?? 100 , width: rect["width"] ??  414, height: rect["height"] ?? 896)
    }
}

typealias JSONDictionary = [String : Any]

func asString(jsonDictionary: JSONDictionary) -> String {
    do {
        let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    } catch {
        return ""
    }
}
