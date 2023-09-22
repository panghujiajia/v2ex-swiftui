//
//  TextView.swift
//  V2EX
//
//  Created by pumbaa on 2023/9/14.
//

import Foundation
import Kingfisher
import SwiftSoup
import SwiftUI

struct ReplyContentView: View {
    let html: String?

    var body: some View {
//        HStack(alignment: .top, spacing: 0){
            if let html {
                let views = convertPlainContent(html: html)
//                renderView(views)
                ForEach(Array(views.enumerated()), id: \.offset) { index, view in
                    if view.type == "TEXT" {
                        renderText(view.value)
                    } else {
                        renderImg(views: view.value)
                    }
                }
            } else {
                Text("无内容")
                    .foregroundColor(.secondary)
            }
//        }
    }
}

struct renderImg: View {
    let views: [ViewInfo]
    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(views.enumerated()), id: \.offset) { index, view in
                handleImg(view.link)
            }
//        }
    }
}

func renderText(_ views: [ViewInfo]) -> some View {
    var text = Text("")
    for view in views {
        switch view.type {
        case "BR":
            // 换行
            text = text + Text("\n")
        case "LINK":
            // 链接
            text = text + handleLink(view.value, view.link)
        default:
            text = text + Text(view.value)
        }
    }
    return text
}

func handleElement(_ node: Element) -> ViewInfo {
    let tagName = node.tagName()
    if tagName == "br" {
        return ViewInfo(
            type: "BR",
            value: "",
            link: ""
        )
    } else if tagName == "a" {
        for cNode in node.getChildNodes() {
            if cNode is TextNode {
                // 字符串链接
                let value = try! node.text().trimmingCharacters(in: .whitespaces)
                let link = try! node.attr("href")
                return ViewInfo(
                    type: "LINK",
                    value: value + " ",
                    link: link
                )
            } else if let elementCNode = cNode as? Element {
                return handleElement(elementCNode)
            }
        }
    } else if tagName == "img" {
        let link = try! node.attr("src")
        return ViewInfo(
            type: "IMG",
            value: "",
            link: link
        )
    }
    return ViewInfo(
        type: "BR",
        value: "",
        link: ""
    )
}

struct ViewInfo: Decodable {
    public let type: String // TEXT LINK IMG BR
    public let value: String
    public let link: String
}

struct ViewList: Decodable {
    public let type : String // TEXT IMG
    public let value: [ViewInfo]
}

func convertPlainContent(html: String) -> [ViewList] {
    let doc = try! SwiftSoup.parseBodyFragment(html)
    let divElement = try! doc.getElementsByTag("div").first()!
    var viewInfo: [ViewInfo] = []
    for pNode in divElement.getChildNodes() {
        if let textNode = pNode as? TextNode {
            // 字符串 直接拼接
            let value = textNode.text().trimmingCharacters(in: .whitespaces)
            if !value.isEmpty {
                viewInfo.append(ViewInfo(
                    type: "TEXT",
                    value: value,
                    link: ""
                ))
            }
        } else if let elementNode = pNode as? Element {
            viewInfo.append(handleElement(elementNode))
        }
    }
    var list: [ViewList] = []
    var text: [ViewInfo] = []
    for view in viewInfo {
        if view.type == "IMG" {
            if text.count != 0 {
                list.append(ViewList(
                    type: "TEXT",
                    value : text
                ))
            }
            list.append(ViewList(
                type: "IMG",
                value : [view]
            ))
            text = []
        } else {
            text.append(view)
        }
    }
    if text.count != 0 {
        list.append(ViewList(
            type: "TEXT",
            value : text
        ))
    }
    return list
}

func handleLink(_ text: String, _ href: String) -> Text {
    var attributedString = AttributedString(text)
    attributedString.link = URL(string: (href))
    // attributedString.cursor = NSCursor.openHand
    return Text(attributedString)
}

func handleImg(_ src: String) -> some View {
    return GeometryReader { geometry in
        KFImage.url(URL(string: src))
            .resizable()
            .scaledToFit()
            .frame(minWidth: 20, minHeight: 20)
            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .topLeading)
    }
    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .topLeading)
//    return KFImage.url(URL(string: src))
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(maxHeight: .infinity)
}
