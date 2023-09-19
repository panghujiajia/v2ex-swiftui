//
//  HTMLView.swift
//  V2EX
//
//  Created by pumbaa on 2023/9/12.
//

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlString: String // 本地HTML文件的文件名
    
    @Binding var webViewHeight: CGFloat // 用于接收WebView高度的绑定变量
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // 设置导航代理
        webView.scrollView.isScrollEnabled = false
        
        webView.configuration.userContentController.add(context.coordinator, name: "getHeight")
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let filepath = Bundle.main.path(forResource: "index", ofType: "html") {
            do {
                var content = try String(contentsOfFile: filepath, encoding: .utf8)
                content = content.replacingOccurrences(of: "{htmlString}", with: htmlString)
                uiView.loadHTMLString(content, baseURL: Bundle.main.bundleURL)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLView
        
        init(_ parent: HTMLView) {
            self.parent = parent
        }
        
        // 当WebView加载完成时触发
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 使用JavaScript获取文档高度
//            webView.evaluateJavaScript("document.documentElement.scrollHeight") { result, error in
//                if let height = result as? CGFloat {
//                    self.parent.webViewHeight = height // 更新高度
//                }
//            }
        }
        
        // This function is essential for intercepting every navigation in the webview
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Suppose you don't want your user to go a restricted site
            // Here you can get many information about new url from 'navigationAction.request.description'
            if let host = navigationAction.request.url?.host {
                // This cancels the navigation
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            }
            // This allows the navigation
            decisionHandler(.allow)
        }
    }
}


// MARK: - Extensions
extension HTMLView.Coordinator: WKScriptMessageHandler {
    
    // 实现WKScriptMessageHandler协议方法来处理JavaScript消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "getHeight", let height = message.body as? CGFloat {
            // 当接收到来自JavaScript的高度消息时，更新WebView的高度
            if(parent.webViewHeight != height){
                parent.webViewHeight = height
            }
        }
    }
}
