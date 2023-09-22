//
//  V2exService.swift
//  V2EX
//
//  Created by pumbaa on 2023/7/9.
//

import Foundation
import SwiftSoup
import V2exAPI

//当前时间与时间戳的差值是否大于 gap 分钟
func isDifferenceFifteenMinutes(timestamp: TimeInterval, gap: Int) -> Bool {
    let currentDate = Date()
    let date = Date(timeIntervalSince1970: timestamp)
    
    let difference = currentDate.timeIntervalSince(date) // 当前时间与时间戳的差值
    return Int(abs(difference)) > (gap * 60)
}
//获取id
func extractNumber(from string: String) -> String? {
    let pattern = "\\d+"
    do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(string.startIndex..., in: string)
        
        if let result = regex.firstMatch(in: string, options: [], range: range) {
            return String(string[Range(result.range, in: string)!])
        }
    } catch {
        print("Error: \(error)")
    }
    return nil
}

/// V2exService
public struct V2exService {
    
    public var session = URLSession.shared
    
    private let prefix = "https://v2ex.com"
    
    /**
     热门帖子
     */
    public func getHotTopics() async -> [Topic]? {
        do {
            let url = URL(string: prefix + "/api/topics/hot.json")!
            
            let (data, _) = try await session.data(from: url)
            
            let decoder = JSONDecoder()
            let product = try decoder.decode([V2Topic].self, from: data)
            
            var result = [Topic]()
            for item in product {
                let obj: Topic = Topic(
                    id: item.id,
                    title: item.title!,
                    replies: item.replies!,
                    node_name: item.node!.title!,
                    node_value: item.node!.name,
                    author: item.member!.username!,
                    avatar: item.member!.avatarLarge!,
                    last_reply_time: ""
                )
                result.append(obj)
            }
            return result
        } catch {
            print("error")
            return []
        }
    }
    
    /**
     获取首页节点下的主题
     */
    public func getTabTopics(tab: String) async -> [Topic]? {
        do {
            let url = URL(string: prefix + "?tab=\(tab)")!
            
            let (data, _) = try await session.data(from: url)
            
            let doc: Document = try SwiftSoup.parse(String(decoding: data, as: UTF8.self))
            
            let els: Elements = try doc.select("#Main .box .item")
            
            var result = [Topic]()
            
            for el in els {
                var id = try el.select(".topic-link").attr("href")
                id = extractNumber(from: String(id))!
                let title = try el.select(".topic-link").text()
                var replies = try el.select("td").last()!.select("a").text()
                replies = replies.isEmpty ? "0" : String(replies)
                let node_name = try el.select(".node").text()
                var node_value = try el.select(".node").attr("href")
                node_value = node_value.split(separator: "/").map(String.init)[1]
                let author = try el.select(".topic_info strong").first()!.children().text()
                let avatar = try el.select(".avatar").attr("src")
                let last_reply_time = try el.select(".topic_info span").text()
                
                let obj: Topic = Topic(
                    id: (id as NSString).integerValue,
                    title: title,
                    replies: (replies as NSString).integerValue,
                    node_name: node_name,
                    node_value: node_value,
                    author: author,
                    avatar: avatar,
                    last_reply_time: last_reply_time
                )
                result.append(obj)
            }
            return result
            
        } catch {
            print("error")
            return []
        }
    }
    
    /**
     获取主题详情
     */
    func getTopicDetail(id: Int, p: Int) async -> Comment? {
        do {
            let url = URL(string: prefix + "/t/\(id)?p=\(p)")!
            
            let (data, _) = try await session.data(from: url)
            
            let doc: Document = try SwiftSoup.parse(String(decoding: data, as: UTF8.self))
            
            let boxs: Elements = try doc.select("#Main .box")
            var master = ""
            var content = ""
            var publish_time = ""
            var page = 1
            
            if boxs.count > 1 {
                page = try boxs.get(1).select(".cell .page_input").first()?.parent()?.select("a").count ?? 1
            } else {
                return nil
            }
            
            let subtle_list = [Subtle]()
            
            var reply_list = [Reply]()
            if p == 1 {
                master = try boxs.get(0).select(".header .gray a").first()!.text()
                content = try boxs.get(0).select(".cell .topic_content").outerHtml()
                publish_time = try boxs.get(0).select(".header .gray span").text()
                
                // 附言
                let subtles: Elements = try boxs.get(0).select(".subtle")
                
                for subtle in subtles {

//                    let subtle_time = try subtle.select(".fade span").text()
//                    let subtle_content = try subtle.select(".topic_content").html()
                    let subtleContent = try subtle.outerHtml()
//                    subtle_list.append(Subtle(
//                        subtle_time: subtle_time,
//                        subtle_content: subtle_content
//                    ))
                    // 附言和主体内容用同一个webview渲染
                    content = content + subtleContent
                }
            }
            
            let replies: Elements = try boxs.get(1).select(".cell")
            for reply in replies {
                let author = try reply.select(".dark").text()
                let avatar = try reply.select(".avatar").attr("src")
                let is_master = master == author
                let reply_time = try reply.select(".ago").text()
                let like_num = try reply.select(".fade").text()
                let content = try reply.select(".reply_content").outerHtml()
                
                if !author.isEmpty {
                    let obj: Reply = Reply(
                        author: author,
                        avatar: avatar,
                        is_master: is_master,
                        reply_time: reply_time,
                        like_num: like_num,
                        content: content
                    )
                    reply_list.append(obj)
                    
//                    let txt: Element = try reply.select(".reply_content").first()!
//                    
//                    for node in txt.getChildNodes() {
//                        if let textNode = node as? TextNode {
//                            // 字符串 直接拼接
////                            text = text + Text(textNode.text().trimmingCharacters(in: .whitespaces))
//                        } else if let elementNode = node as? Element {
//                            let tagName = elementNode.tagName()
//                            // 节点 对应处理
//                            if tagName == "br" {
////                                text = text + Text("\n")
//                            } else if tagName == "a" {
//                                
//                                if let txNode = elementNode.childNode(0) as? TextNode {
//                                    print("文字")
//                                    print(txNode)
//                                } else if let elNode = elementNode.childNode(0) as? Element{
//                                    print("节点")
//                                    print(elNode)
//                                }
//                            } else {
////                                try! text = text + dispatchInline(elementNode)
//                            }
//                        }
//                    }
                }
            }
            
            return Comment(
                page: page,
                content: content,
                publish_time: publish_time,
                subtle_list: subtle_list,
                reply_list: reply_list
            )
            
        } catch {
            print("error")
            return nil
        }
    }
    
}
