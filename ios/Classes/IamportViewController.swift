//
//  IamportViewController.swift
//  flutter_iamport
//
//  Created by YoonJae Park on 28/06/2019.
//

import UIKit
import WebKit
import Flutter

class IamportViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
  
    let DEFAULT_REDIRECT_URL_WHEN_SUCCESS = "https://service.iamport.kr/payments/success"
    let DEFAULT_REDIRECT_URL_WHEN_FAILURE = "https://service.iamport.kr/payments/fail"
    var loadding = [
        "message" : "",
        "image" : ""
    ]
    var channel: FlutterMethodChannel!
    var loadingFinished: Bool = false
    var webView: WKWebView!
    var param = ""
    var rect: CGRect!
    var userCode: String!
    
    
    convenience init(userCode: String, rect: CGRect, param: String, loadding: [String : String]) {
        self.init()
        self.userCode = userCode
        self.rect = rect
        self.loadding = loadding
        self.param = param
    }
    
    override func loadView() {
        super.loadView()
        let frameSize = view.bounds.size
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        self.view.frame = CGRect(x: self.rect.minX, y: self.rect.minY, width: self.rect.width, height: self.rect.height)
        webView = WKWebView(frame: CGRect(x: self.rect.minX, y: 0, width: self.rect.width, height: self.rect.height), configuration: configuration)
        
        let messenger = UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController
        self.channel = FlutterMethodChannel.init(name: "flutter_iamport", binaryMessenger: messenger)
        
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.translatesAutoresizingMaskIntoConstraints = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(self.webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let podBundle = Bundle(for: FlutterIamportPlugin.self)
        
        if let url = podBundle.url(forResource: "flutter_iamport", withExtension: "bundle") {
            let bundle = Bundle(url: url)

            if let url = bundle!.url(forResource: "html", withExtension: "bundle") {
                let bundle = Bundle(url: url)

                if let url = bundle!.url(forResource: "www/payment", withExtension: "html") {
                let request = URLRequest(url: url)

                webView.load(request)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(action) in completionHandler(false)})
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in completionHandler(true)})
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
    }
    
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){

        if (!loadingFinished) {
            let triggerCallback = ""
            webView.evaluateJavaScript("IMP.init('" + self.userCode! + "');")
            webView.evaluateJavaScript("IMP.request_pay(" + self.param + ", " + triggerCallback + ");");
           webView.evaluateJavaScript("document.getElementById('imp-rn-img').src = '" + self.loadding["image"]! + "';")
            webView.evaluateJavaScript("document.getElementById('imp-rn-msg').innerText = '" + self.loadding["message"]! + "';")
            self.loadingFinished = true
        }
       
        // 결제 완료
        if (isPaymentOver(url: webView.url!.absoluteString)) {
            channel.invokeMethod("onState", arguments: webView.url!.query)
        }
    }
    
    @available
    (iOS 8.0, *) func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if self.isUrlStartsWithAppScheme(uri: navigationAction.request.url!.absoluteString) {
            let splittedUrl = navigationAction.request.url!.absoluteString.components(separatedBy: "://");
            let scheme = splittedUrl[0];
            let marketUrl : String = scheme == "itmss" ? "https://" + splittedUrl[1] : navigationAction.request.url!.absoluteString;
            // 앱 오픈
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(navigationAction.request.url!)
            }
            UIApplication.shared.openURL(URL(fileURLWithPath: marketUrl))
            
            decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    func isUrlStartsWithAppScheme(uri : String) -> Bool {
        let splittedScheme = uri.components(separatedBy: "://");
        let scheme = splittedScheme[0];
        return scheme != "http" && scheme != "https" && scheme != "about:blank" && scheme != "file";
    }
    
    /* 결제가 종료되었는지 여부를 판단한다 */
    func isPaymentOver(url: String) -> Bool {
        if (url.hasPrefix(self.DEFAULT_REDIRECT_URL_WHEN_FAILURE) || url.hasPrefix(self.DEFAULT_REDIRECT_URL_WHEN_SUCCESS)) {
            return true;
        }
        
        return false;
    }
}

