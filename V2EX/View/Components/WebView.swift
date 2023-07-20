//
//  WebView.swift
//  V2EX
//
//  Created by pumbaa on 2023/7/16.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    var html: String
    var notificationName: String
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.addObserver(context.coordinator, forKeyPath: "scrollView.contentSize", options: .new, context: nil)
        return webView
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var webViewHeight: CGFloat = .zero
        init(_ parent: WebView) {
            self.parent = parent
        }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "scrollView.contentSize" {
                if let webView = object as? WKWebView {
                    // 发送通知
                    if webView.scrollView.contentSize.height > webViewHeight {
                        webViewHeight = webView.scrollView.contentSize.height
                        NotificationCenter.default.post(name: Notification.Name(self.parent.notificationName), object: webViewHeight)
                    }
                }
            }
        }
    }
}
struct TopicReplyHtmlView: View {
    @State private var height: CGFloat = .zero
    var html: String
    var index: Int

    var body: some View {
        VStack {
            WebView(html: html, notificationName: "replyHtmlHeight_\(index)")
                .frame(height: height)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("replyHtmlHeight_\(index)"))) { msg in
            height = msg.object as! CGFloat
        }
    }
}


struct TopicContentHtmlView: View {
    @State private var height: CGFloat = .zero
    var html: String

    var body: some View {
        VStack {
            WebView(html: html, notificationName: "contentHtmlHeight")
                .frame(height: height)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("contentHtmlHeight"))) { msg in
            height = msg.object as! CGFloat
        }
    }
}



struct TopicSubtleHtmlView: View {
    @State private var height: CGFloat = .zero
    var html: String
    var index: Int

    var body: some View {
        VStack {
            WebView(html: html, notificationName: "subtleHtmlHeight_\(index)")
                .frame(height: height)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("subtleHtmlHeight_\(index)"))) { msg in
            height = msg.object as! CGFloat
        }
    }
}
