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
            
            var subtle_list = [Subtle]()
            
            var reply_list = [Reply]()
            
            if p == 1 {
                master = try boxs.get(0).select(".header .gray a").first()!.text()
                content = try boxs.get(0).select(".cell .topic_content").text()
                publish_time = try boxs.get(0).select(".header .gray span").attr("title")
                publish_time = getDateFromTime(time: publish_time).fromNow()
                
                // 附言
                let subtles: Elements = try boxs.get(0).select(".subtle")
                
                for subtle in subtles {

                    var subtle_time = try subtle.select(".fade span").attr("title")
                    let subtle_content = try subtle.select(".topic_content").html()
                    subtle_time = getDateFromTime(time: subtle_time).fromNow()
                    subtle_list.append(Subtle(
                        subtle_time: subtle_time,
                        subtle_content: subtle_content
                    ))
                }
                
                
                let replies: Elements = try boxs.get(1).select(".cell")
                
                for reply in replies {
                    let author = try reply.select(".dark").text()
                    let avatar = try reply.select(".avatar").attr("src")
                    let is_master = master == author
                    var reply_time = try reply.select(".ago").attr("title")
                    let like_num = try reply.select(".fade").text()
                    let content = try reply.select(".reply_content").text()
                    
                    if !author.isEmpty {
                        reply_time = getDateFromTime(time: reply_time).fromNow()
                        let obj: Reply = Reply(
                            author: author,
                            avatar: avatar,
                            is_master: is_master,
                            reply_time: reply_time,
                            like_num: like_num,
                            content: content
                        )
                        reply_list.append(obj)
                    }
                }
            }
            return Comment(
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
