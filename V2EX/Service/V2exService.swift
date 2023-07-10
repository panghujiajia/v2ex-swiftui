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

//字符串转Date
func getDateFromTime(time:String) -> Date{
    let dateformatter = DateFormatter()
    //自定义日期格式
    dateformatter.dateFormat="yyyy-MM-dd HH:mm:ss Z"
    return dateformatter.date(from: time)!
}
//当前时间与时间戳的差值是否大于 gap 分钟
func isDifferenceFifteenMinutes(timestamp: TimeInterval, gap: Int) -> Bool {
    let currentDate = Date()
    let date = Date(timeIntervalSince1970: timestamp)
    
    let difference = currentDate.timeIntervalSince(date) // 当前时间与时间戳的差值
    return Int(abs(difference)) > (gap * 60)
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
                    last_reply_time: Date(timeIntervalSince1970: TimeInterval(item.lastModified!)).fromNow()
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
     获取指定节点下的主题
     */
    public func getTabTopics(tab: String) async -> [Topic]? {
        do {
            let url = URL(string: prefix + "?tab=\(tab)")!
            
            let (data, _) = try await session.data(from: url)
            
            let doc: Document = try SwiftSoup.parse(String(decoding: data, as: UTF8.self))
            
            let links: Elements = try doc.select("#Main .box .item")
            
            var result = [Topic]()
            
            for el in links {
                let id = try el.select(".topic-link").attr("href")
                let title = try el.select(".topic-link").text()
                var replies = try el.select("td").last()!.select("a").text()
                replies = replies.isEmpty ? "0" : String(replies)
                let node_name = try el.select(".node").text()
                var node_value = try el.select(".node").attr("href")
                node_value = node_value.split(separator: "/").map(String.init)[1]
                let author = try el.select(".topic_info strong").first()!.children().text()
                let avatar = try el.select(".avatar").attr("src")
                let last_reply_time = try el.select(".topic_info span").attr("title")
                
                let obj: Topic = Topic(
                    id: (id as NSString).integerValue,
                    title: title,
                    replies: (replies as NSString).integerValue,
                    node_name: node_name,
                    node_value: node_value,
                    author: author,
                    avatar: avatar,
                    last_reply_time: getDateFromTime(time: last_reply_time).fromNow()
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
