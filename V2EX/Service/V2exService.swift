//
//  V2exAPI.swift
//  V2EX
//
//  Created by pumbaa on 2023/7/9.
//

import Foundation
import V2exAPI
import SwiftSoup



extension Date {
    func fromNow() -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first!)
        
        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: self, relativeTo: Date.now)
        
        return relativeDate
    }
}

/// V2exService
public struct V2exService {
    
    public var session = URLSession.shared
    
    private let prefix = "https://v2ex.com"
    
    /**
     HTTP 请求
     */
    public func request() async -> String {
        do {
            
            let url = URL(string: prefix + "/?tab=tech")!
            
            let (data, _) = try await session.data(from: url)
            
            return String(decoding: data, as: UTF8.self)
        } catch {
            print("error")
            return ""
        }
    }
    
    /**
     热门帖子
     */
    public func getHotTopics() async -> [Topic]? {
        do {
            let url = URL(string: prefix + "/api/topics/hot.json")!
            
            let (data, _) = try await session.data(from: url)
//            print(String(decoding: data, as: UTF8.self))
            return try JSONDecoder().decode([Topic].self, from: data)
        } catch {
            print("error")
            return []
        }
    }
    
    /**
     获取指定节点下的主题
     */
    public func getTabTopics(tab: String) async -> [Topic]? {
        do {
            let url = URL(string: prefix + "?tab=\(tab)")!
            
            let (data, _) = try await session.data(from: url)
            
            let doc: Document = try SwiftSoup.parse(String(decoding: data, as: UTF8.self))
            
            let links: Elements = try doc.select("#Main .box .item")
            
            var result = [Topic]()
            
            for (index, el) in links.enumerated() {
                let id = try el.select(".topic-link").attr("href")
                let title = try el.select(".topic-link").text()
                var replies = try el.select("td").last()!.select("a").text()
                replies = replies.isEmpty ? "0" : String(replies)
                let node_name = try el.select(".node").text()
                var node_value = try el.select(".node").attr("href")
                node_value = node_value.split(separator: "/").map(String.init)[1]
                let author = try el.select(".topic_info strong").first()!.children().text()
                let avatar = try el.select(".avatar").attr("src")
                let last_reply_time = try el.select(".topic_info span").text()
                if index < 2 {
//                    print((
//                        id: id,
//                        title: title,
//                        replies: replies,
//                        node_name: node_name,
//                        node_value: node_value,
//                        author: author,
//                        avatar: avatar,
//                        last_reply_time: last_reply_time
//                    ))
                }
                let obj: Topic = Topic(
                    id: (id as NSString).integerValue,
                    title: title,
                    content: "",
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
    
}
